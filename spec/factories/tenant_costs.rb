# == Schema Information
#
# Table name: tenant_costs
#
#  id             :bigint           not null, primary key
#  expenses_sum   :integer          not null
#  month          :integer          not null
#  tenant_paid    :integer          default(0)
#  tenant_paid_at :datetime
#  year           :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_tenant_costs_on_month_and_year  (month,year)
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
