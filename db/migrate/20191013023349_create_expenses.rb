# typed: true

class CreateExpenses < ActiveRecord::Migration[6.0]
  def change
    create_table :expenses do |t|
      t.string :name
      t.integer :value
      t.integer :month
      t.integer :year
      t.datetime :expense_at
      t.timestamps
    end

    add_index(:expenses, %i[month year])
    add_index(:expenses, %i[month year name value], unique: true)
  end
end
