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

ActiveRecord::Schema[8.1].define(version: 2026_08_17_115231) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "paths", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "highway_cost", precision: 8, scale: 2, default: "0.0"
    t.decimal "lenght", precision: 8, scale: 2, default: "0.0"
    t.string "name"
    t.integer "position"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_paths_on_user_id"
  end

  create_table "places", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "position"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_places_on_user_id"
  end

  create_table "reasons", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "position"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_reasons_on_user_id"
  end

  create_table "transports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "position"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_transports_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false, null: false
    t.string "category"
    t.string "confirmator"
    t.string "confirmator_presentation"
    t.string "confirmator_signature"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "gender"
    t.string "institute"
    t.string "last_name"
    t.boolean "manager", default: false, null: false
    t.string "office"
    t.string "province"
    t.string "region"
    t.boolean "regular", default: false, null: false
    t.datetime "remember_created_at"
    t.datetime "updated_at", null: false
    t.string "user_signature"
    t.string "username", null: false
    t.string "validator"
    t.string "validator_presentation"
    t.string "validator_signature"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "vehicles", force: :cascade do |t|
    t.decimal "cost_per_km", precision: 8, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.string "licence_plate"
    t.string "name"
    t.integer "position"
    t.string "producer"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_vehicles_on_user_id"
  end

  add_foreign_key "paths", "users"
  add_foreign_key "places", "users"
  add_foreign_key "reasons", "users"
  add_foreign_key "transports", "users"
  add_foreign_key "vehicles", "users"
end
