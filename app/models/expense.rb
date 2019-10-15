# == Schema Information
#
# Table name: expenses
#
#  id         :bigint           not null, primary key
#  expense_at :datetime
#  month      :integer
#  name       :string
#  value      :decimal(5, 2)
#  year       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_expenses_on_month_and_year  (month,year)
#

# typed: strong

class Expense < ApplicationRecord
  validate :must_be_valid_expense
  VALID_EXPENSES = %w[SPL RTV GEN-I TELEMACH]

  def self.parse_expense_row(raw_expenses)
    # ['GEN-I, D.O.O.', '03.10.2019', 'some text', '-52,00 EUR'],
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
