# typed: true

class CreateTenantCosts < ActiveRecord::Migration[6.0]
  def change
    create_table :tenant_costs do |t|
      t.integer :month, null: false
      t.integer :year, null: false
      t.integer :expenses_sum, null: false
      t.integer :tenant_paid, default: 0
      t.datetime :tenant_paid_at
      t.timestamps
    end

    add_index :tenant_costs, %i[month year]
  end
end
