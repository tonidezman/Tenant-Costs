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
    same_month_expenses =
      expenses.group_by { |expense| [expense.month, expense.year] }

    same_month_expenses.each do |month_year, expenses|
      expenses_sum = expenses.map(&:value).sum + MONTHLY_APARTMENT_EXPENSE
      tenant_cost =
        TenantCost.find_or_initialize_by(
          month: month_year[0], year: month_year[1]
        )
      tenant_cost.expenses_sum = expenses_sum
      tenant_cost.save
    end

    tenant_payments.each do |tenant_payment|
      tenant_paid_at = tenant_payment.expense_at
      month = tenant_paid_at.month
      year = tenant_paid_at.year

      most_expenses_due_day = 18
      payment_for_the_last_month = tenant_paid_at.day < most_expenses_due_day
      month -= 1 if payment_for_the_last_month

      tenant_cost = TenantCost.find_by(month: month, year: year)
      log_errors(tenant_cost, tenant_payment)
      raise if tenant_cost.expenses_sum != tenant_payment.value

      tenant_cost.tenant_paid = tenant_payment.value
      tenant_cost.tenant_paid_at = tenant_payment.expense_at
      tenant_cost.save
    end
  end

  def already_payed?
    expenses_sum == tenant_paid && tenant_paid_at.present?
  end

  def log_errors(tenant_cost, tenant_payment)
    if tenant_cost.blank?
      Rails.logger.error "TenantCost.find_by(month: #{month}, year: #{
                           year
                         }) is not in DB!"
    end

    if tenant_cost.already_payed?
      Rails.logger.info "TenantCost: #{tenant_cost.id} already payed for."
    end

    if tenant_cost.expenses_sum != tenant_payment.value
      Rails.logger.error "TenantCost: #{tenant_cost.id} doesn't have value of #{
                           tenant_payment.value
                         }"
    end
  end
end
