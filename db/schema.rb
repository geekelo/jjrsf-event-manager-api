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

ActiveRecord::Schema[7.2].define(version: 2025_05_09_151130) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "event_attendees", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "address"
    t.string "email"
    t.string "whatsapp"
    t.string "phone"
    t.string "gender"
    t.boolean "member", default: false
    t.string "preferred_attendance"
    t.boolean "attended_online", default: false
    t.boolean "attended_offline", default: false
    t.string "otp", null: false
    t.uuid "foundation_event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "family", default: false
    t.string "family_members", default: [], array: true
    t.index ["email"], name: "index_event_attendees_on_email"
    t.index ["foundation_event_id"], name: "index_event_attendees_on_foundation_event_id"
    t.index ["otp"], name: "index_event_attendees_on_otp", unique: true
  end

  create_table "event_feedbacks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "testimony"
    t.text "review"
    t.string "name", default: "Anonymous"
    t.uuid "foundation_event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["foundation_event_id"], name: "index_event_feedbacks_on_foundation_event_id"
  end

  create_table "event_front_desks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "pin", null: false
    t.uuid "foundation_event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["foundation_event_id"], name: "index_event_front_desks_on_foundation_event_id"
    t.index ["pin"], name: "index_event_front_desks_on_pin", unique: true
  end

  create_table "event_notes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "content", null: false
    t.string "admin_name", null: false
    t.uuid "event_attendee_id"
    t.uuid "event_quick_registration_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_attendee_id"], name: "index_event_notes_on_event_attendee_id"
    t.index ["event_quick_registration_id"], name: "index_event_notes_on_event_quick_registration_id"
  end

  create_table "event_quick_registrations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "gender"
    t.string "otp", null: false
    t.boolean "attended_online", default: false
    t.boolean "attended_offline", default: false
    t.boolean "verified", default: false
    t.uuid "foundation_event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "family", default: false
    t.string "family_members", default: [], array: true
    t.index ["foundation_event_id"], name: "index_event_quick_registrations_on_foundation_event_id"
  end

  create_table "event_streaming_platforms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "platform_name", null: false
    t.text "embed_code"
    t.string "embed_link"
    t.string "visit_link"
    t.uuid "foundation_event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["foundation_event_id"], name: "index_event_streaming_platforms_on_foundation_event_id"
  end

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
    t.boolean "visibility", default: true, null: false
    t.datetime "start_time", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "end_time", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "registration_deadline_time", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "registration_deadline_status", default: "open", null: false
    t.index ["event_user_id"], name: "index_foundation_events_on_event_user_id"
    t.index ["unique_id"], name: "index_foundation_events_on_unique_id", unique: true
  end

  add_foreign_key "event_attendees", "foundation_events"
  add_foreign_key "event_feedbacks", "foundation_events"
  add_foreign_key "event_front_desks", "foundation_events"
  add_foreign_key "event_notes", "event_attendees"
  add_foreign_key "event_notes", "event_quick_registrations"
  add_foreign_key "event_quick_registrations", "foundation_events"
  add_foreign_key "event_streaming_platforms", "foundation_events"
  add_foreign_key "foundation_events", "event_users"
end
