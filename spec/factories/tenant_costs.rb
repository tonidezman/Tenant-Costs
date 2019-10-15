# == Schema Information
#
# Table name: tenant_costs
#
#  expenses_sum   :decimal(5, 2)
#  month          :integer
#  tenant_paid    :decimal(, )
#  tenant_paid_at :datetime
#  year           :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_tenant_costs_on_month_and_year  (month,year) UNIQUE
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
