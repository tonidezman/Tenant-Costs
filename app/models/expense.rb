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

# typed: strong

class Expense < ApplicationRecord
  validate :must_be_valid_expense
  VALID_EXPENSES = %w[SPL RTV GEN-I TELEMACH]
  TENANT = ENV['MY_TENANTS_NAME']

  def self.get_current_months_expenses
    Expense.where(month: Time.now.month)
  end

  def self.process(raw_expenses_mixed)
    tenant_payments = []
    expenses = []

    parse_expense_rows(raw_expenses_mixed).each do |expense|
      if expense.valid?
        expenses << expense
        expense.save if Expense.expense_not_in_db?(expense)
      elsif expense.tenant_payment?
        tenant_payments << expense
      end
    end

    TenantCost.process(tenant_payments, expenses)
  end

  def tenant_payment?
    name.downcase.match?(ENV['MY_TENANTS_NAME'].downcase)
  end

  def self.expense_not_in_db?(expense)
    Expense.where(
      month: expense.month,
      year: expense.year,
      name: expense.name,
      value: expense.value
    )
      .blank?
  end

  def self.parse_expense_rows(raw_expenses_mixed)
    result = []
    raw_expenses_mixed.each do |raw_expense|
      next if raw_expense.blank?
      name, expense_at, _, raw_value = raw_expense
      expense_at = expense_at.to_date
      value = MoneyParser.parse(raw_value)

      result <<
        Expense.new(
          name: name,
          expense_at: expense_at,
          value: value.abs,
          month: expense_at.month,
          year: expense_at.year
        )
    end
    result
  end

  def must_be_valid_expense
    is_valid_expense = false

    VALID_EXPENSES.each do |expense|
      is_valid_expense = true if name.upcase.include? expense
    end

    errors.add(:name, 'this is not valid expense') unless is_valid_expense
  end

  def to_s
    "#{name} #{value / 100.0} EUR #{year}-#{month}"
  end
end

class InvalidExpense < StandardError; end
