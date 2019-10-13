# == Schema Information
#
# Table name: expenses
#
#  id         :bigint           not null, primary key
#  expense_at :datetime
#  month      :string
#  name       :string
#  value      :decimal(5, 2)
#  year       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_expenses_on_month_and_year  (month,year)
#

# typed: false
require 'rails_helper'

RSpec.describe Expense, type: :model do
end
