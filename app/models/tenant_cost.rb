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

# typed: strong

class TenantCost < ApplicationRecord
  validates :month, uniqueness: { scope: :year }

  MONTHLY_APARTMENT_EXPENSE = 24_000

  def self.process(tenant_payments, expenses)
    # process just the current month expense

    p :tonko
  end
end
