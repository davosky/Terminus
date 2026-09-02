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

ActiveRecord::Schema[8.1].define(version: 2026_09_02_122742) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "mission_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "departure_date"
    t.decimal "highway_cost_fr", precision: 8, scale: 2, default: "0.0"
    t.string "name"
    t.string "path_fr"
    t.bigint "path_id"
    t.decimal "path_lenght_fr", precision: 8, scale: 2, default: "0.0"
    t.string "place_fr"
    t.bigint "place_id"
    t.string "reason_fr"
    t.bigint "reason_id"
    t.text "rejection_motivation"
    t.boolean "request_approved"
    t.date "request_date"
    t.date "return_date"
    t.string "structure_fr"
    t.bigint "structure_id"
    t.bigint "transport_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "vehicle_id"
    t.index ["name"], name: "index_mission_requests_on_name", unique: true
    t.index ["path_id"], name: "index_mission_requests_on_path_id"
    t.index ["place_id"], name: "index_mission_requests_on_place_id"
    t.index ["reason_id"], name: "index_mission_requests_on_reason_id"
    t.index ["structure_id"], name: "index_mission_requests_on_structure_id"
    t.index ["transport_id"], name: "index_mission_requests_on_transport_id"
    t.index ["user_id"], name: "index_mission_requests_on_user_id"
    t.index ["vehicle_id"], name: "index_mission_requests_on_vehicle_id"
  end

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

  create_table "reimbursements", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "departure_date"
    t.decimal "food_cost", precision: 8, scale: 2, default: "0.0"
    t.decimal "generic_cost", precision: 8, scale: 2, default: "0.0"
    t.decimal "highway_cost_fr", precision: 8, scale: 2, default: "0.0"
    t.bigint "mission_request_id"
    t.string "name"
    t.decimal "parking_cost", precision: 8, scale: 2, default: "0.0"
    t.string "path_fr"
    t.bigint "path_id"
    t.decimal "path_lenght_fr", precision: 8, scale: 2, default: "0.0"
    t.string "place_fr"
    t.bigint "place_id"
    t.string "reason_fr"
    t.bigint "reason_id"
    t.date "reimbursement_date"
    t.date "request_date"
    t.date "return_date"
    t.decimal "room_cost", precision: 8, scale: 2, default: "0.0"
    t.string "structure_fr"
    t.bigint "structure_id"
    t.decimal "ticket_cost", precision: 8, scale: 2, default: "0.0"
    t.decimal "total_amount", precision: 8, scale: 2, default: "0.0"
    t.bigint "transport_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "vehicle_id"
    t.index ["mission_request_id"], name: "index_reimbursements_on_mission_request_id", unique: true, where: "(mission_request_id IS NOT NULL)"
    t.index ["name"], name: "index_reimbursements_on_name", unique: true
    t.index ["path_id"], name: "index_reimbursements_on_path_id"
    t.index ["place_id"], name: "index_reimbursements_on_place_id"
    t.index ["reason_id"], name: "index_reimbursements_on_reason_id"
    t.index ["structure_id"], name: "index_reimbursements_on_structure_id"
    t.index ["transport_id"], name: "index_reimbursements_on_transport_id"
    t.index ["user_id"], name: "index_reimbursements_on_user_id"
    t.index ["vehicle_id"], name: "index_reimbursements_on_vehicle_id"
  end

  create_table "structures", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "position"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_structures_on_user_id"
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
    t.integer "failed_attempts", default: 0, null: false
    t.string "first_name"
    t.string "gender"
    t.string "institute"
    t.string "last_name"
    t.datetime "locked_at"
    t.boolean "manager", default: false, null: false
    t.boolean "mission_requesting_user", default: false, null: false
    t.string "office"
    t.boolean "payroll", default: false, null: false
    t.string "province"
    t.string "region"
    t.boolean "regular", default: false, null: false
    t.datetime "remember_created_at"
    t.string "unlock_token"
    t.datetime "updated_at", null: false
    t.string "user_signature"
    t.string "username", null: false
    t.string "validator"
    t.string "validator_presentation"
    t.string "validator_signature"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
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

  add_foreign_key "mission_requests", "paths"
  add_foreign_key "mission_requests", "places"
  add_foreign_key "mission_requests", "reasons"
  add_foreign_key "mission_requests", "structures"
  add_foreign_key "mission_requests", "transports"
  add_foreign_key "mission_requests", "users"
  add_foreign_key "mission_requests", "vehicles"
  add_foreign_key "paths", "users"
  add_foreign_key "places", "users"
  add_foreign_key "reasons", "users"
  add_foreign_key "reimbursements", "mission_requests", on_delete: :nullify
  add_foreign_key "reimbursements", "paths"
  add_foreign_key "reimbursements", "places"
  add_foreign_key "reimbursements", "reasons"
  add_foreign_key "reimbursements", "structures"
  add_foreign_key "reimbursements", "transports"
  add_foreign_key "reimbursements", "users"
  add_foreign_key "reimbursements", "vehicles"
  add_foreign_key "structures", "users"
  add_foreign_key "transports", "users"
  add_foreign_key "vehicles", "users"
end
