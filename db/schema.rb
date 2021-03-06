# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_13_023507) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "expenses", force: :cascade do |t|
    t.string "name"
    t.integer "value"
    t.integer "month"
    t.integer "year"
    t.datetime "expense_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["month", "year", "name", "value"], name: "index_expenses_on_month_and_year_and_name_and_value", unique: true
    t.index ["month", "year"], name: "index_expenses_on_month_and_year"
  end

  create_table "tenant_costs", force: :cascade do |t|
    t.integer "month", null: false
    t.integer "year", null: false
    t.integer "expenses_sum", null: false
    t.integer "tenant_paid", default: 0
    t.datetime "tenant_paid_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["month", "year"], name: "index_tenant_costs_on_month_and_year"
  end

end
