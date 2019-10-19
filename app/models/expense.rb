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

  def self.expense_not_in_db?(expense)
    Expense.where(
      month: expense.month,
      year: expense.year,
      name: expense.name,
      value: expense.value
    )
      .one?
  end

  def self.process(raw_expenses)
    expenses_sum = 0
    first_expense = nil
    parse_expense_rows(raw_expenses).each do |expense|
      first_expense = expense if first_expense.nil?

      if expense.valid?
        expenses_sum += expense.value
        expense.save if Expense.expense_not_in_db?(expense)
      end
    end
    tenant_cost =
      TenantCost.find_or_initialize_by(
        month: first_expense.month, year: first_expense.year
      )

    tenant_cost.expenses_sum = expenses_sum.abs
    tenant_cost.save
  end

  def self.parse_expense_rows(raw_expenses)
    result = []
    raw_expenses.each do |raw_expense|
      name, expense_at, _, raw_value = raw_expense
      expense_at = expense_at.to_date
      value = MoneyParser.parse(raw_value)
      result <<
        Expense.new(
          name: name,
          expense_at: expense_at,
          value: value,
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
end

class InvalidExpense < StandardError; end
