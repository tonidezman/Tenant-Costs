# == Schema Information
#
# Table name: expenses
#
#  id         :integer          not null, primary key
#  name       :string
#  month      :string
#  year       :string
#  expense_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# typed: false
FactoryBot.define do
  factory :expense do
    name 'MyString'
    expense_at '2019-10-13 04:33:49'
    month 'MyString'
    year 'MyString'
  end
end
