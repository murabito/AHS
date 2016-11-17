# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20161117200032) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clinical_summaries", force: :cascade do |t|
    t.string   "document_id"
    t.integer  "patient_id"
    t.integer  "ehr_system_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "clinical_summaries", ["ehr_system_id"], name: "index_clinical_summaries_on_ehr_system_id", using: :btree
  add_index "clinical_summaries", ["patient_id"], name: "index_clinical_summaries_on_patient_id", using: :btree

  create_table "ehr_systems", force: :cascade do |t|
    t.string   "redox_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patients", force: :cascade do |t|
    t.string  "mrn"
    t.string  "dob"
    t.string  "ssn"
    t.string  "last_name"
    t.string  "first_name"
    t.integer "ehr_system_id"
  end

  add_index "patients", ["ehr_system_id"], name: "index_patients_on_ehr_system_id", using: :btree
  add_index "patients", ["mrn"], name: "index_patients_on_mrn", using: :btree

  create_table "recent_views", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "is_saved",            default: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "clinical_summary_id"
  end

  add_index "recent_views", ["clinical_summary_id"], name: "index_recent_views_on_clinical_summary_id", using: :btree
  add_index "recent_views", ["is_saved"], name: "index_recent_views_on_is_saved", using: :btree
  add_index "recent_views", ["user_id"], name: "index_recent_views_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "clinical_summaries", "ehr_systems"
  add_foreign_key "clinical_summaries", "patients"
  add_foreign_key "patients", "ehr_systems"
  add_foreign_key "recent_views", "clinical_summaries"
  add_foreign_key "recent_views", "users"
end
