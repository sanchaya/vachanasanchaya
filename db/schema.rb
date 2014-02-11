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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140211185948) do

  create_table "concords", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.string   "concord_code"
    t.integer  "count"
    t.text     "ids"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "concords", ["count"], :name => "index_concords_on_count"
  add_index "concords", ["parent_id"], :name => "index_concords_on_parent_id"

  create_table "daily_vachanas", :force => true do |t|
    t.integer  "vachana_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "daily_vachanas", ["vachana_id"], :name => "index_daily_vachanas_on_vachana_id"

  create_table "database_connections", :force => true do |t|
    t.string  "adapter",  :null => false
    t.string  "database", :null => false
    t.string  "password"
    t.string  "username"
    t.string  "host"
    t.string  "encoding"
    t.integer "port"
    t.string  "title"
  end

  create_table "key_words", :force => true do |t|
    t.string   "word"
    t.integer  "count"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.text     "vachana_ids"
    t.text     "vachanakaara_ids"
  end

  add_index "key_words", ["word"], :name => "index_key_words_on_word"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "user_role"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "vachanakaaras", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "ankitha_naama"
    t.string   "time_period"
    t.integer  "vachana_found"
    t.boolean  "sex"
    t.text     "information"
    t.string   "parents"
    t.string   "spouse"
    t.string   "birth_place"
  end

  add_index "vachanakaaras", ["ankitha_naama"], :name => "index_vachanakaaras_on_ankitha_naama"
  add_index "vachanakaaras", ["name"], :name => "index_vachanakaaras_on_name"

  create_table "vachanas", :force => true do |t|
    t.integer  "vachanaid"
    t.string   "name"
    t.text     "vachana"
    t.integer  "vachanakaara_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "vachanas", ["vachanaid"], :name => "index_vachanas_on_vachanaid"
  add_index "vachanas", ["vachanakaara_id"], :name => "index_vachanas_on_vachanakaara_id"

  create_table "word_lists", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "exact_search_count", :default => 0
    t.integer  "like_search_count",  :default => 0
  end

end
