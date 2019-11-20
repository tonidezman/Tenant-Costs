class ExpensesController < ApplicationController
  def index
    time = Time.now
    @year_month = "#{time.year}-#{time.month}"
    @current_month_expenses = Expense.print_current_month_expenses
  end
end
