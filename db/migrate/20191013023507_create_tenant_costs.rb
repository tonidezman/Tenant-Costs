class CreateTenantCosts < ActiveRecord::Migration[6.0]
  def change
    create_table :tenant_costs do |t|
      t.string :month
      t.string :year
      t.integer :expenses_sum
      t.integer :paid
      t.datetime :paid_at

      t.timestamps
    end
  end
end
