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

ActiveRecord::Schema.define(version: 20170718003154) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "golfers", force: :cascade do |t|
    t.string   "first_name",      null: false
    t.string   "last_name",       null: false
    t.string   "pga_player_id",   null: false
    t.string   "pga_profile_url", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "picks", force: :cascade do |t|
    t.integer  "pool_id",             null: false
    t.integer  "user_id",             null: false
    t.integer  "golfer_id"
    t.integer  "pool_participant_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "picks", ["golfer_id"], name: "index_picks_on_golfer_id", using: :btree
  add_index "picks", ["pool_id"], name: "index_picks_on_pool_id", using: :btree
  add_index "picks", ["pool_participant_id"], name: "index_picks_on_pool_participant_id", using: :btree
  add_index "picks", ["user_id"], name: "index_picks_on_user_id", using: :btree

  create_table "pool_participants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id",    null: false
    t.integer  "pool_id",    null: false
  end

  add_index "pool_participants", ["pool_id"], name: "index_pool_participants_on_pool_id", using: :btree
  add_index "pool_participants", ["user_id"], name: "index_pool_participants_on_user_id", using: :btree

  create_table "pools", force: :cascade do |t|
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "name",                                   null: false
    t.integer  "creator_id",                             null: false
    t.integer  "tournament_id",                          null: false
    t.string   "pool_type"
    t.integer  "number_picks",               default: 7, null: false
    t.string   "password"
    t.integer  "number_golfers_for_scoring", default: 5
  end

  add_index "pools", ["creator_id"], name: "index_pools_on_creator_id", using: :btree
  add_index "pools", ["name"], name: "index_pools_on_name", using: :btree
  add_index "pools", ["tournament_id"], name: "index_pools_on_tournament_id", using: :btree

  create_table "rounds", force: :cascade do |t|
    t.integer  "round_number",         null: false
    t.integer  "tournament_golfer_id", null: false
    t.integer  "total_strokes"
    t.integer  "hole_1"
    t.integer  "hole_2"
    t.integer  "hole_3"
    t.integer  "hole_4"
    t.integer  "hole_5"
    t.integer  "hole_6"
    t.integer  "hole_7"
    t.integer  "hole_8"
    t.integer  "hole_9"
    t.integer  "hole_10"
    t.integer  "hole_11"
    t.integer  "hole_12"
    t.integer  "hole_13"
    t.integer  "hole_14"
    t.integer  "hole_15"
    t.integer  "hole_16"
    t.integer  "hole_17"
    t.integer  "hole_18"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "rounds", ["tournament_golfer_id"], name: "index_rounds_on_tournament_golfer_id", using: :btree

  create_table "tournament_golfers", force: :cascade do |t|
    t.integer  "tournament_id", null: false
    t.integer  "golfer_id",     null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "total"
  end

  add_index "tournament_golfers", ["golfer_id"], name: "index_tournament_golfers_on_golfer_id", using: :btree
  add_index "tournament_golfers", ["tournament_id"], name: "index_tournament_golfers_on_tournament_id", using: :btree

  create_table "tournaments", force: :cascade do |t|
    t.string   "name",                                          null: false
    t.string   "url",                                           null: false
    t.string   "status",                   default: "upcoming", null: false
    t.datetime "start_date_and_time",                           null: false
    t.boolean  "instantiated?",            default: false
    t.datetime "end_date_and_time",                             null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "strokes_per_round_to_par"
  end

  add_index "tournaments", ["name"], name: "index_tournaments_on_name", using: :btree

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
    t.boolean  "admin"
    t.string   "first_name",                          null: false
    t.string   "last_name",                           null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
