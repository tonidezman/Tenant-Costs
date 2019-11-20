class ExpensesController < ApplicationController
  def index
    @current_month_expenses = Expense.print_current_month_expenses
  end
end
