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
FactoryBot.define do
  factory :expense do
    name { 'SPL' }
    expense_at { '2019-10-13 04:33:49' }
    month { 'Jan' }
    year { '2019' }
  end
end
