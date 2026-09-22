# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_09_14_010000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bike_models", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bikes", force: :cascade do |t|
    t.bigint "bike_model_id", null: false
    t.string "serial_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bike_model_id"], name: "index_bikes_on_bike_model_id"
    t.index ["serial_number"], name: "index_bikes_on_serial_number", unique: true
  end

  create_table "customers", force: :cascade do |t|
    t.string "name", null: false
    t.string "phone", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "price", precision: 8, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_jobs_on_name", unique: true
  end

  create_table "repair_jobs", force: :cascade do |t|
    t.bigint "repair_id", null: false
    t.bigint "job_id", null: false
    t.decimal "price_charged", precision: 8, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_repair_jobs_on_job_id"
    t.index ["repair_id"], name: "index_repair_jobs_on_repair_id"
  end

  create_table "repairs", force: :cascade do |t|
    t.bigint "bike_id", null: false
    t.bigint "customer_id", null: false
    t.bigint "mechanic_id"
    t.string "status", default: "dropped_off", null: false
    t.date "promised_on", null: false
    t.datetime "picked_up_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bike_id"], name: "index_repairs_on_bike_id"
    t.index ["customer_id"], name: "index_repairs_on_customer_id"
    t.index ["mechanic_id"], name: "index_repairs_on_mechanic_id"
  end

  create_table "staff_members", force: :cascade do |t|
    t.string "name", null: false
    t.string "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bikes", "bike_models"
  add_foreign_key "repair_jobs", "jobs"
  add_foreign_key "repair_jobs", "repairs"
  add_foreign_key "repairs", "bikes"
  add_foreign_key "repairs", "customers"
  add_foreign_key "repairs", "staff_members", column: "mechanic_id"
end
