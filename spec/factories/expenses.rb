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
FactoryBot.define do
  factory :expense do
    name { 'SPL' }
    expense_at { '2019-10-13 04:33:49' }
    month { 10 }
    year { 2_019 }
  end
end
