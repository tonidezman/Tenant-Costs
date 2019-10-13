# typed: true
class CreateTenantCosts < ActiveRecord::Migration[6.0]
  def change
    create_table :tenant_costs, id: false do |t|
      t.string   :month
      t.string   :year
      t.integer  :expenses_sum
      t.integer  :paid
      t.datetime :paid_at
      t.timestamps
    end

    add_index :tenant_costs, [:month, :year], unique: true
  end
end
