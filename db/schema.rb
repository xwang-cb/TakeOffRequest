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

ActiveRecord::Schema.define(version: 20150302114716) do

  create_table "details", force: :cascade do |t|
    t.string   "user_id",    limit: 255
    t.integer  "hours",      limit: 4
    t.string   "type",       limit: 255
    t.datetime "start_date"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "summaries", force: :cascade do |t|
    t.integer  "year",           limit: 4
    t.string   "type",           limit: 255
    t.integer  "taken",          limit: 4
    t.integer  "left_last_year", limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "user_id",        limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.string "name",        limit: 255
    t.string "email",       limit: 255
    t.string "status",      limit: 255
    t.date   "joined_date"
  end

  create_table "year_preferences", force: :cascade do |t|
    t.integer "year",       limit: 4
    t.date    "clean_date"
  end

end
