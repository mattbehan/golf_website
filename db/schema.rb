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

ActiveRecord::Schema.define(version: 20170612124904) do

  create_table "golfers", force: :cascade do |t|
    t.string   "first_name",      null: false
    t.string   "last_name",       null: false
    t.string   "pga_player_id",   null: false
    t.string   "pga_profile_url", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "picks", force: :cascade do |t|
    t.integer  "pool_id",    null: false
    t.integer  "user_id",    null: false
    t.integer  "golfer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "picks", ["pool_id"], name: "index_picks_on_pool_id"
  add_index "picks", ["user_id"], name: "index_picks_on_user_id"

  create_table "pool_participants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id",    null: false
    t.integer  "pool_id",    null: false
  end

  add_index "pool_participants", ["pool_id"], name: "index_pool_participants_on_pool_id"
  add_index "pool_participants", ["user_id"], name: "index_pool_participants_on_user_id"

  create_table "pools", force: :cascade do |t|
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "name",                      null: false
    t.integer  "creator_id",                null: false
    t.integer  "tournament_id",             null: false
    t.string   "pool_type"
    t.integer  "number_picks",  default: 7, null: false
    t.string   "password"
  end

  add_index "pools", ["creator_id"], name: "index_pools_on_creator_id"
  add_index "pools", ["name"], name: "index_pools_on_name"
  add_index "pools", ["tournament_id"], name: "index_pools_on_tournament_id"

  create_table "tournament_golfers", force: :cascade do |t|
    t.integer  "tournament_id", null: false
    t.integer  "golfer_id",     null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "tournament_golfers", ["golfer_id"], name: "index_tournament_golfers_on_golfer_id"
  add_index "tournament_golfers", ["tournament_id"], name: "index_tournament_golfers_on_tournament_id"

  create_table "tournaments", force: :cascade do |t|
    t.string   "name",                            null: false
    t.string   "url",                             null: false
    t.string   "status",     default: "upcoming", null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "tournaments", ["name"], name: "index_tournaments_on_name"

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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
