# == Schema Information
#
# Table name: expenses
#
#  id         :bigint           not null, primary key
#  expense_at :datetime
#  month      :integer
#  name       :string
#  value      :integer
#  year       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_expenses_on_month_and_year                     (month,year)
#  index_expenses_on_month_and_year_and_name_and_value  (month,year,name,value) UNIQUE
#

# typed: false

require 'rails_helper'

RSpec.describe Expense, type: :model do
  before { ENV['MY_TENANTS_NAME'] = 'Bob' }

  describe '#tenant_payment?' do
    it "returns false if it doesn't match MY_TENANTS_NAME env" do
      expense = build(:expense, value: 100, name: 'Bob')
      expect(expense.tenant_payment?).to be true
    end

    it 'returns true if it matches tenant data' do
      ENV['MY_TENANTS_NAME'] = 'marry'
      expense = build(:expense, value: 100, name: 'Bob')
      expect(expense.tenant_payment?).to be false
    end
  end

  describe 'cents_to_eur helper function' do
    it 'returns correct print of the cents to eur' do
      expense = build(:expense, value: 100)
      expect(expense.cents_to_eur).to eq('1.00 €')
      expense.value = 33_569
      expect(expense.cents_to_eur).to eq('335.69 €')
    end
  end

  describe '.print_current_month_expenses' do
    it 'correctly displays all current month expenses' do
      current_month = Time.now.month
      create(:expense, month: current_month, value: 100, name: 'SPL')
      create(:expense, month: current_month, value: 200, name: 'telemach')
      create(:expense, month: current_month, value: 300, name: 'rtv')

      expected = <<~EOL
        1.00 € SPL (2019-11)
        2.00 € telemach (2019-11)
        3.00 € rtv (2019-11)
        4.00 € najemnina
        ---------------------------------
        10.00 €
      EOL

      expect(Expense.print_current_month_expenses(rent: 400)).to eq(expected)
    end
  end

  describe '.current_month_expenses' do
    it 'returns correct months expenses' do
      current_month = Time.now.month
      create(:expense, month: current_month)
      create(:expense, month: current_month)
      create(:expense, month: current_month - 1)
      create(:expense, month: current_month - 1)
      create(:expense, month: current_month - 2)
      expect(Expense.current_month_expenses.count).to eq(2)
    end
  end

  describe '#to_s' do
    it 'returns human friendly string for expense' do
      expense = build(:expense, value: 10_077, month: 10, year: 2_020)
      expect(expense.to_s).to eq('100.77 € SPL (2020-10)')
    end
  end

  describe '.process' do
    context 'Correctly handles Tenant payments' do
      it 'saves tenant payment for previous month (before 18th in month)' do
        # We have expenses that are not yet payed from the previous month
        Expense.process(raw_expenses_only(offset: 1.month))
        expect(TenantCost.count).to eq(1)
        tenant_cost = TenantCost.first
        expect(tenant_cost.tenant_paid).to be_zero

        # tenant pays for the expenses on the 16th
        Expense.process(raw_only_tenant_payment(offset: 5.days))
        expect(TenantCost.count).to eq(1)
        tenant_cost = TenantCost.first
        expect(tenant_cost.expenses_sum).to eq(tenant_cost.tenant_paid)
      end

      it 'saves tenant payment for current month (on 28 in this month)' do
        # Expenses for the current month
        Expense.process(raw_expenses_only(offset: 5.days))
        # Tenant pays on the 20th for the current month expenses
        Expense.process(raw_only_tenant_payment(offset: 0.days))

        expect(TenantCost.count).to eq(1)
        tenant_cost = TenantCost.first
        expect(tenant_cost.expenses_sum).to eq(tenant_cost.tenant_paid)
      end
    end

    it 'correctly saves tvo SPL costs to the databases' do
      # you should not miss two expenses
      # tenant should pay everything and not just one cost
    end

    it 'creates TenantCost row for the sum of all valid expenses' do
      expect(TenantCost.count).to eq(0)
      Expense.process(raw_expenses_missing_one_expense)
      expect(TenantCost.count).to eq(1)
      expect(TenantCost.first.tenant_paid).to eq(0)
      expect(TenantCost.first.expenses_sum).to eq(43_801)

      # on multiple runs it doesn't create new TenantCost row
      Expense.process(raw_expenses_only(offset: 5.days))
      expect(TenantCost.count).to eq(1)
      expect(TenantCost.first.expenses_sum).to eq(45_076)
      expect(Expense.count).to eq(4)

      # tenant pays the monthly expenses for previous month
      Expense.process(raw_expenses(offset: 1.month))
      Expense.process(raw_only_tenant_payment(offset: 5.days))
      expect(TenantCost.count).to eq(2)
      prev_month = raw_date(1.month).to_date
      tenant_cost =
        TenantCost.find_by(month: prev_month.month, year: prev_month.year)

      expect(tenant_cost.tenant_paid).to eq(45_076)
      expect(tenant_cost.expenses_sum).to eq(tenant_cost.tenant_paid)
      expect(tenant_cost.tenant_paid_at).to eq(raw_date(5.days).to_date)
      expect(tenant_cost.month).to eq(prev_month.month)
      expect(tenant_cost.year).to eq(prev_month.year)
    end
  end

  describe '.parse_expense_rows' do
    it 'converts raw expense data to Expense objects' do
      expect(
        Expense.parse_expense_rows(raw_expenses_mixed).all? { |expense|
          expense.is_a? Expense
        }
      ).to be true
    end

    it 'saves expense only once (idempotent) on multiple runs' do
      expect(Expense.count).to eq(0)
      begin
        Expense.parse_expense_rows(raw_expenses_mixed).each(&:save)
        Expense.parse_expense_rows(raw_expenses_mixed).each(&:save)
      rescue ActiveRecord::RecordNotUnique
        # nothing to do
      end
      expect(Expense.count).to eq(4)

      # sanity check, money is important :)
      expect(Expense.last.value).to eq(1_275)
    end

    it 'gets back only valid tenant expenses' do
      expenses = Expense.parse_expense_rows(raw_expenses_mixed)
      counter = 0
      expenses.each { |expense| counter += 1 if expense.valid? }
      expect(counter).to eq(4)
    end
  end
end
