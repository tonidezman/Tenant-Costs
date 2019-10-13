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
require 'rails_helper'

RSpec.describe TenantCost, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
