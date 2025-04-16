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

ActiveRecord::Schema[7.2].define(version: 2025_04_16_183803) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "event_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.string "role", default: "user", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_event_users_on_email", unique: true
  end

  create_table "foundation_events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "unique_id", null: false
    t.string "name", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.text "description", null: false
    t.boolean "online", default: true, null: false
    t.boolean "onsite", default: true, null: false
    t.string "location"
    t.date "registration_deadline", null: false
    t.string "evaluation"
    t.string "image_url", null: false
    t.string "status", default: "upcoming", null: false
    t.uuid "event_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_user_id"], name: "index_foundation_events_on_event_user_id"
    t.index ["unique_id"], name: "index_foundation_events_on_unique_id", unique: true
  end

  add_foreign_key "foundation_events", "event_users"
end
