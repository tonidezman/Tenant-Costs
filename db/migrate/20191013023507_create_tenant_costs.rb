# typed: true

class CreateTenantCosts < ActiveRecord::Migration[6.0]
  def change
    create_table :tenant_costs, id: false do |t|
      t.integer :month
      t.integer :year
      t.integer :expenses_sum
      t.decimal :tenant_paid
      t.datetime :tenant_paid_at
      t.timestamps
    end

    add_index :tenant_costs, %i[month year], unique: true
  end
end
