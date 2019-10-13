# == Schema Information
#
# Table name: tenant_costs
#
#  expenses_sum   :decimal(5, 2)
#  month          :string
#  tenant_paid    :decimal(, )
#  tenant_paid_at :datetime
#  year           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_tenant_costs_on_month_and_year  (month,year) UNIQUE
#

# typed: false
require 'rails_helper'

RSpec.describe TenantCost, type: :model do
end
