# == Schema Information
#
# Table name: tenant_costs
#
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
#  index_tenant_costs_on_month_and_year  (month,year) UNIQUE
#

# typed: strong

class TenantCost < ApplicationRecord; end
