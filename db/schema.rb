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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110420043956) do

  create_table "alternatives", :force => true do |t|
    t.string   "name"
    t.integer  "index"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "decisions", :force => true do |t|
    t.string   "name"
    t.string   "intern"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "open_at"
    t.datetime "closed_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "voters", :force => true do |t|
    t.string   "email"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "hashed_secret"
    t.string   "public_identifier"
    t.string   "salt"
  end

  create_table "votes", :force => true do |t|
    t.integer  "voter_id"
    t.integer  "vote_ordinal"
    t.integer  "decision_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
