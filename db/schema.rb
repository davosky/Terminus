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

ActiveRecord::Schema[8.1].define(version: 2026_08_15_173334) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

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
end
