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

ActiveRecord::Schema[8.1].define(version: 2026_07_14_193030) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "cash_registers", force: :cascade do |t|
    t.datetime "closed_at"
    t.datetime "created_at", null: false
    t.datetime "opened_at"
    t.decimal "opening_balance", precision: 10, scale: 2, default: "0.0"
    t.string "status", default: "open"
    t.datetime "updated_at", null: false
  end

  create_table "guests", force: :cascade do |t|
    t.string "city"
    t.string "company"
    t.datetime "created_at", null: false
    t.string "document"
    t.string "name", null: false
    t.text "notes"
    t.string "phone"
    t.string "plate"
    t.datetime "updated_at", null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.datetime "check_in", null: false
    t.datetime "check_out", null: false
    t.datetime "created_at", null: false
    t.bigint "guest_id", null: false
    t.text "notes"
    t.string "reservation_type", default: "paga"
    t.bigint "room_id", null: false
    t.string "status", default: "confirmed"
    t.datetime "updated_at", null: false
    t.index ["guest_id"], name: "index_reservations_on_guest_id"
    t.index ["room_id"], name: "index_reservations_on_room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.boolean "active", default: true
    t.integer "capacity", default: 2, null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.text "notes"
    t.string "number", null: false
    t.decimal "price_1p", precision: 10, scale: 2, default: "0.0"
    t.decimal "price_2p", precision: 10, scale: 2, default: "0.0"
    t.string "room_type"
    t.string "status", default: "available", null: false
    t.datetime "updated_at", null: false
    t.index ["number"], name: "index_rooms_on_number", unique: true
  end

  create_table "showers", force: :cascade do |t|
    t.string "cabin"
    t.datetime "created_at", null: false
    t.datetime "end_time"
    t.string "guest_name"
    t.string "payment_method"
    t.datetime "start_time"
    t.string "status", default: "active"
    t.datetime "updated_at", null: false
    t.decimal "value", precision: 10, scale: 2, default: "20.0"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "cash_register_id"
    t.datetime "created_at", null: false
    t.string "description"
    t.string "origin", null: false
    t.string "payment_method"
    t.string "responsible"
    t.string "status", default: "pending"
    t.string "transaction_type", null: false
    t.datetime "updated_at", null: false
    t.decimal "value", precision: 10, scale: 2, default: "0.0", null: false
    t.index ["cash_register_id"], name: "index_transactions_on_cash_register_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.string "password_digest"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "reservations", "guests"
  add_foreign_key "reservations", "rooms"
  add_foreign_key "transactions", "cash_registers"
end
