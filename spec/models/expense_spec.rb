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

  describe '.process' do
    context 'Correctly handles Tenant payments' do
      it 'saves tenant payment for previous month (before 18th in month)' do
        # We have expenses that are not yet payed from the previous month
        Expense.process(raw_expenses(offset: 1.month))
        # tenant pays for the expenses on the 15th
        Expense.process(raw_only_tenant_payment(offset: 5.days))

        # because tenant didn't pay for the last month this should get marked a payed
        expect(TenantCost.count).to eq(2)
        prev_month = raw_date(1.month).to_date
        prev_month_tenant_cost =
          TenantCost.find_by(month: prev_month.month, year: prev_month.year)
        expect(prev_month_tenant_cost.tenant_paid).to eq(45_076)

        # current months tenant cost are not yet payed
        curr_month = raw_date(1.day).to_date
        curr_month_tenant_cost =
          TenantCost.find_by(month: curr_month.month, year: curr_month.year)
        expect(curr_month_tenant_cost.tenant_paid).to be_zero

        # tenant pays current month on the 20th
        Expense.process(raw_only_tenant_payment(offset: 0.days))
        curr_month_tenant_cost =
          TenantCost.find_by(month: curr_month.month, year: curr_month.year)
        expect(curr_month_tenant_cost.tenant_paid).to eq(45_076)
      end

      it 'saves tenant payment for current month (on 28 in this month)' do
        # we need to check that previous month was payed and current months expenses are equal what tenant has payed
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
