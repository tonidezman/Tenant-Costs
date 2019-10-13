class CreateExpenses < ActiveRecord::Migration[6.0]
  def change
    create_table :expenses do |t|
      t.string   :name
      t.string   :month
      t.string   :year
      t.datetime :expense_at
      t.timestamps
    end

    add_index(:expenses, [:month, :year])
  end
end
