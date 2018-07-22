# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180720002217) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "concepts", force: :cascade do |t|
    t.integer  "song_id"
    t.string   "name"
    t.boolean  "rhythm"
    t.boolean  "prepare"
    t.boolean  "present"
    t.boolean  "practice"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["song_id"], name: "index_concepts_on_song_id", using: :btree
  end

  create_table "field_categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "field_entries", force: :cascade do |t|
    t.string   "data"
    t.integer  "song_id"
    t.integer  "field_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["field_id"], name: "index_field_entries_on_field_id", using: :btree
    t.index ["song_id"], name: "index_field_entries_on_song_id", using: :btree
  end

  create_table "fields", force: :cascade do |t|
    t.string   "name"
    t.integer  "display_type"
    t.integer  "field_category_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "options"
    t.index ["field_category_id"], name: "index_fields_on_field_category_id", using: :btree
  end

  create_table "songs", force: :cascade do |t|
    t.string   "title"
    t.string   "comments"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
    t.integer  "source_id"
    t.string   "image_id"
    t.string   "image_path"
    t.string   "image2_id"
    t.string   "image2_path"
    t.string   "image3_id"
    t.string   "image3_path"
    t.string   "image4_id"
    t.string   "image4_path"
  end

  create_table "sources", force: :cascade do |t|
    t.string   "title"
    t.string   "author"
    t.string   "publisher"
    t.string   "city"
    t.integer  "copyright_year"
    t.string   "web_site"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.string   "invited_by_type"
    t.integer  "invited_by_id"
    t.integer  "invitations_count",      default: 0
    t.boolean  "admin",                  default: false
    t.integer  "failed_attempts",        default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.boolean  "manager",                default: false
    t.string   "display_name"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  end

  add_foreign_key "concepts", "songs"
end
