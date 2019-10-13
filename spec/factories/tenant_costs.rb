# == Schema Information
#
# Table name: tenant_costs
#
#  month        :string
#  year         :string
#  expenses_sum :integer
#  paid         :integer
#  paid_at      :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

# typed: false
FactoryBot.define do
  factory :tenant_cost do
    month { 'MyString' }
    year { 'MyString' }
    expenses_sum { 1 }
    paid { 1 }
    paid_at { '2019-10-13 04:35:07' }
  end
end
