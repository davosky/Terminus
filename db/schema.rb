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

ActiveRecord::Schema[8.1].define(version: 2026_10_12_110000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "paths", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "lenght", precision: 8, scale: 2, null: false
    t.decimal "highway_cost", precision: 8, scale: 2, default: "0.0", null: false
    t.integer "position", null: false
    t.integer "user_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_code"], name: "index_paths_on_user_code"
  end

  create_table "places", force: :cascade do |t|
    t.string "name", null: false
    t.integer "position", null: false
    t.integer "user_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_code"], name: "index_places_on_user_code"
  end

  create_table "transports", force: :cascade do |t|
    t.string "transport_name", null: false
    t.integer "transport_position", null: false
    t.boolean "locked", default: false, null: false
    t.integer "user_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_code"], name: "index_transports_on_user_code"
  end

  create_table "users", force: :cascade do |t|
    t.serial "user_code", null: false
    t.string "username", null: false
    t.string "email", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "gender", limit: 1, null: false
    t.string "region", limit: 3, null: false
    t.string "province", limit: 3, null: false
    t.string "institute", null: false
    t.string "office", null: false
    t.string "category"
    t.boolean "admin", default: false, null: false
    t.boolean "manager", default: false, null: false
    t.boolean "payroll", default: false, null: false
    t.boolean "regular", default: false, null: false
    t.boolean "reimbursement_request", default: false, null: false
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["user_code"], name: "index_users_on_user_code", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "producer", null: false
    t.string "name", null: false
    t.string "licence_plate", null: false
    t.string "power", null: false
    t.decimal "cost_per_km", precision: 8, scale: 2, default: "0.0", null: false
    t.integer "position", null: false
    t.integer "user_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_code"], name: "index_vehicles_on_user_code"
  end

  add_foreign_key "paths", "users", column: "user_code", primary_key: "user_code"
  add_foreign_key "places", "users", column: "user_code", primary_key: "user_code"
  add_foreign_key "transports", "users", column: "user_code", primary_key: "user_code"
  add_foreign_key "vehicles", "users", column: "user_code", primary_key: "user_code"
end
