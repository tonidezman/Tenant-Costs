class CreateExpenses < ActiveRecord::Migration[6.0]
  def change
    create_table :expenses do |t|
      t.string :name
      t.datetime :expense_at
      t.string :month
      t.string :year

      t.timestamps
    end
  end
end
