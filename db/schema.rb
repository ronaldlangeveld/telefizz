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

ActiveRecord::Schema[8.1].define(version: 2026_01_06_101401) do
  create_table "board_integrations", force: :cascade do |t|
    t.integer "board_id", null: false
    t.datetime "created_at", null: false
    t.integer "integration_id", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id"], name: "index_board_integrations_on_board_id"
    t.index ["integration_id"], name: "index_board_integrations_on_integration_id"
  end

  create_table "boards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.string "secret"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "uuid"
    t.index ["user_id"], name: "index_boards_on_user_id"
  end

  create_table "integrations", force: :cascade do |t|
    t.json "config"
    t.datetime "created_at", null: false
    t.string "name"
    t.string "type"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_integrations_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "login_token"
    t.datetime "login_token_sent_at"
    t.string "password_digest"
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["login_token"], name: "index_users_on_login_token", unique: true
  end

  create_table "webhook_events", force: :cascade do |t|
    t.string "action"
    t.integer "board_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id"], name: "index_webhook_events_on_board_id"
  end

  add_foreign_key "board_integrations", "boards"
  add_foreign_key "board_integrations", "integrations"
  add_foreign_key "boards", "users"
  add_foreign_key "integrations", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "webhook_events", "boards"
end
