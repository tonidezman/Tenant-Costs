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
  describe '#tenant_payment?' do
    it "returns false if it doesn't match MY_TENANTS_NAME env" do
      expense = build(:expense, value: 100, name: 'Bob')
      ENV['MY_TENANTS_NAME'] = 'bob'
      expect(expense.tenant_payment?).to be true
    end

    it 'returns true if it matches tenant data' do
      expense = build(:expense, value: 100, name: 'Bob')
      ENV['MY_TENANTS_NAME'] = 'marry'
      expect(expense.tenant_payment?).to be false
    end
  end

  describe '.process' do
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
      Expense.process(raw_expenses_only)

      expect(TenantCost.count).to eq(1)
      expect(TenantCost.first.expenses_sum).to eq(45_076)
      expect(Expense.count).to eq(4)

      # tenant pays the monthly expenses
      Expense.process(raw_only_tenant_payment)
      expect(TenantCost.count).to eq(1)
      tenant_cost = TenantCost.first

      expect(tenant_cost.tenant_paid).to eq(45_076)
      expect(tenant_cost.tenant_paid_at).to raw_date(5.days.ago)
      month, year = raw_date.split('.')[0, 2]
      expect(tenant_cost.month).to eq(month)
      expect(tenant_cost.year).to eq(year)
    end
  end

  describe '.parse_expense_rows' do
    it 'correctly parses raw record data from the scraper' do
      expect { Expense.parse_expense_rows(raw_expenses) }.not_to raise_error(
                      InvalidExpense
                    )
    end

    it 'converts raw expense data to Expense objects' do
      expect(
        Expense.parse_expense_rows(raw_expenses).all? { |expense|
          expense.is_a? Expense
        }
      ).to be true
    end

    it 'saves expense only once (idempotent) on multiple runs' do
      expect(Expense.count).to eq(0)
      begin
        Expense.parse_expense_rows(raw_expenses).each(&:save)
        Expense.parse_expense_rows(raw_expenses).each(&:save)
      rescue ActiveRecord::RecordNotUnique
        # nothing to do
      end
      expect(Expense.count).to eq(4)

      # sanity check, money is important :)
      expect(Expense.last.value).to eq(1_275)
    end

    it 'gets back only valid tenant expenses' do
      expenses = Expense.parse_expense_rows(raw_expenses)
      counter = 0
      expenses.each { |expense| counter += 1 if expense.valid? }
      expect(counter).to eq(4)
    end
  end

  def raw_expenses
    [
      ['Bank inc.', raw_date(0.days), 'some text', '-75,41 EUR'],
      ['Bank inc.', raw_date(1.days), 'some text', '-13,04 EUR'],
      ['Bank inc.', raw_date(2.days), 'some text', '-22,77 EUR'],
      ['Bank inc.', raw_date(3.days), 'some text', '-5,74 EUR'],
      ['Bank inc.', raw_date(4.days), 'some text', '-50,98 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-41,59 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-84,00 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-42,60 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-62,59 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '0,01 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-0,10 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-1,70 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-1,07 EUR'],
      ['VZAJEMNA', raw_date(5.days), 'some text', '-34,60 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-0,33 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-0,33 EUR'],
      ['VRTEC', raw_date(5.days), 'OSKRBNINE', '-169,63 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-31,50 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-4,52 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-11,40 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-2,01 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-20,92 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-1,70 EUR'],
      ['MARY SMITH', raw_date(5.days), 'Drugo', '450,78 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-3,40 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-68,00 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-7,40 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-13,40 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-18,10 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-218,79 EUR'],
      ['SPL D.D.', raw_date(5.days), 'DB SEP 2019', '-103,01 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-0,33 EUR'],
      ['TELEMACH D.O.O.', raw_date(2.days), 'some text', '-43,00 EUR'],
      ['GEN-I, D.O.O.', raw_date(2.days), 'some text', '-52,00 EUR'],
      ['RTV SLOVENIJA', raw_date(3.days), 'some text', '-12,75 EUR']
    ]
  end

  def raw_only_tenant_payment
    [['MARY SMITH', raw_date(5.days), 'Drugo', '210,76 EUR']]
  end

  def raw_expenses_missing_one_expense
    [
      ['MARY SMITH', raw_date(5.days), 'Drugo', '450,78 EUR'],
      ['SPL D.D.', raw_date(5.days), 'DB SEP 2019', '-103,01 EUR'],
      ['TELEMACH D.O.O.', raw_date(2.days), 'some text', '-43,00 EUR'],
      ['GEN-I, D.O.O.', raw_date(2.days), 'some text', '-52,00 EUR']
    ]
  end

  def raw_expenses_only
    [
      ['MARY SMITH', raw_date(5.days), 'Drugo', '450,78 EUR'],
      ['SPL D.D.', raw_date(5.days), 'DB SEP 2019', '-103,01 EUR'],
      ['TELEMACH D.O.O.', raw_date(2.days), 'some text', '-43,00 EUR'],
      ['GEN-I, D.O.O.', raw_date(2.days), 'some text', '-52,00 EUR'],
      ['RTV SLOVENIJA', raw_date(3.days), 'some text', '-12,75 EUR']
    ]
  end

  def raw_date(days_ago, current_date: nil)
    if current_date.nil?
      current_date = DateTime.now.beginning_of_month + 20.days
    end
    (current_date - days_ago).strftime('%d.%m.%Y')
  end
end
