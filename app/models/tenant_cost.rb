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

# typed: strong

class TenantCost < ApplicationRecord; end
