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

ActiveRecord::Schema.define(:version => 20270603000000) do

  create_table "activities", :force => true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "activities", ["owner_id", "owner_type"], :name => "index_activities_on_owner_id_and_owner_type"
  add_index "activities", ["recipient_id", "recipient_type"], :name => "index_activities_on_recipient_id_and_recipient_type"
  add_index "activities", ["trackable_id", "trackable_type"], :name => "index_activities_on_trackable_id_and_trackable_type"

  create_table "concord_items", :force => true do |t|
    t.integer "concord_id", :null => false
    t.integer "item_id",    :null => false
  end

  add_index "concord_items", ["concord_id", "item_id"], :name => "index_concord_items_on_concord_and_item", :unique => true
  add_index "concord_items", ["item_id"], :name => "index_concord_items_on_item_id"

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

  add_index "daily_vachanas", ["created_at"], :name => "index_daily_vachanas_on_created_at"
  add_index "daily_vachanas", ["vachana_id"], :name => "index_daily_vachanas_on_vachana_id"

  create_table "donation_reminders", :force => true do |t|
    t.string   "email",                           :null => false
    t.string   "phone"
    t.string   "source",     :default => "popup"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "donation_reminders", ["created_at"], :name => "index_donation_reminders_on_created_at"
  add_index "donation_reminders", ["email"], :name => "index_donation_reminders_on_email"

  create_table "donations", :force => true do |t|
    t.string   "donor_name"
    t.string   "donor_email"
    t.string   "payment_id"
    t.string   "razorpay_order_id"
    t.decimal  "amount",            :precision => 10, :scale => 2
    t.string   "currency",                                         :default => "INR"
    t.string   "status",                                           :default => "pending"
    t.text     "notes"
    t.datetime "paid_at"
    t.datetime "created_at",                                                              :null => false
    t.datetime "updated_at",                                                              :null => false
  end

  add_index "donations", ["paid_at"], :name => "index_donations_on_paid_at"
  add_index "donations", ["payment_id"], :name => "index_donations_on_payment_id"
  add_index "donations", ["razorpay_order_id"], :name => "index_donations_on_razorpay_order_id"
  add_index "donations", ["status"], :name => "index_donations_on_status"

  create_table "glossaries", :force => true do |t|
    t.string   "word"
    t.text     "meanings"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "glossaries", ["word"], :name => "index_glossaries_on_word"

  create_table "key_words", :force => true do |t|
    t.string   "word"
    t.integer  "count"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.text     "vachana_ids"
    t.text     "vachanakaara_ids"
  end

  add_index "key_words", ["word"], :name => "index_key_words_on_word"

  create_table "keyword_vachanakaaras", :force => true do |t|
    t.integer "key_word_id",     :null => false
    t.integer "vachanakaara_id", :null => false
  end

  add_index "keyword_vachanakaaras", ["key_word_id", "vachanakaara_id"], :name => "index_kw_vas_on_keyword_and_vachanakaara", :unique => true
  add_index "keyword_vachanakaaras", ["vachanakaara_id"], :name => "index_kw_vas_on_vachanakaara_id"

  create_table "keyword_vachanas", :force => true do |t|
    t.integer "key_word_id",                :null => false
    t.integer "vachana_id",                 :null => false
    t.integer "count",       :default => 0, :null => false
  end

  add_index "keyword_vachanas", ["key_word_id", "vachana_id"], :name => "index_kw_vachanas_on_keyword_and_vachana", :unique => true
  add_index "keyword_vachanas", ["vachana_id"], :name => "index_kw_vachanas_on_vachana_id"

  create_table "old_vachanas", :force => true do |t|
    t.integer  "vachana_id"
    t.text     "old_vachana"
    t.integer  "old_vachanaid"
    t.string   "old_name"
    t.integer  "reviewer_id"
    t.integer  "publisher_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "old_vachanas", ["publisher_id"], :name => "index_old_vachanas_on_publisher_id"
  add_index "old_vachanas", ["reviewer_id"], :name => "index_old_vachanas_on_reviewer_id"
  add_index "old_vachanas", ["vachana_id"], :name => "index_old_vachanas_on_vachana_id"

  create_table "reference_books", :force => true do |t|
    t.string   "book_name"
    t.string   "book_volume"
    t.string   "publisher"
    t.string   "author"
    t.string   "published_year"
    t.string   "isbn"
    t.string   "language"
    t.string   "reference_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "review_comments", :force => true do |t|
    t.integer  "review_vachana_id"
    t.text     "comment"
    t.integer  "user_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "review_comments", ["review_vachana_id"], :name => "index_review_comments_on_review_vachana_id"
  add_index "review_comments", ["user_id"], :name => "index_review_comments_on_user_id"

  create_table "review_vachanas", :force => true do |t|
    t.integer  "vachana_id"
    t.integer  "reviewer_id"
    t.boolean  "published"
    t.integer  "publisher_id"
    t.text     "review_vachana"
    t.integer  "review_vachanaid"
    t.string   "review_name"
    t.boolean  "reviewed"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "review_vachanas", ["publisher_id"], :name => "index_review_vachanas_on_publisher_id"
  add_index "review_vachanas", ["reviewer_id"], :name => "index_review_vachanas_on_reviewer_id"
  add_index "review_vachanas", ["vachana_id"], :name => "index_review_vachanas_on_vachana_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "static_pages", :force => true do |t|
    t.string   "slug"
    t.string   "title"
    t.text     "body"
    t.string   "locale"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "static_pages", ["slug", "locale"], :name => "index_static_pages_on_slug_and_locale", :unique => true

  create_table "user_feedbacks", :force => true do |t|
    t.integer  "feedbackable_id"
    t.string   "feedbackable_type"
    t.integer  "user_id"
    t.text     "comment",                                  :null => false
    t.string   "status",            :default => "pending"
    t.string   "ip_address"
    t.string   "user_agent"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "name"
    t.string   "email"
  end

  add_index "user_feedbacks", ["feedbackable_id", "feedbackable_type"], :name => "idx_user_feedbacks_on_feedbackable"
  add_index "user_feedbacks", ["status"], :name => "index_user_feedbacks_on_status"
  add_index "user_feedbacks", ["user_id"], :name => "index_user_feedbacks_on_user_id"

  create_table "user_vachanakaaras", :force => true do |t|
    t.integer  "vachanakaara_id"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "user_vachanakaaras", ["user_id"], :name => "index_user_vachanakaaras_on_user_id"
  add_index "user_vachanakaaras", ["vachanakaara_id"], :name => "index_user_vachanakaaras_on_vachanakaara_id"

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
    t.integer  "role_id"
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "vachanakaaras", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "ankitha_naama"
    t.string   "time_period"
    t.integer  "vachana_found"
    t.boolean  "sex"
    t.text     "information"
    t.string   "parents"
    t.string   "spouse"
    t.string   "birth_place"
    t.integer  "reference_book_id"
    t.string   "slug_name"
    t.string   "slug"
  end

  add_index "vachanakaaras", ["ankitha_naama"], :name => "index_vachanakaaras_on_ankitha_naama"
  add_index "vachanakaaras", ["name"], :name => "index_vachanakaaras_on_name"
  add_index "vachanakaaras", ["reference_book_id"], :name => "index_vachanakaaras_on_reference_book_id"
  add_index "vachanakaaras", ["slug"], :name => "index_vachanakaaras_on_slug", :unique => true

  create_table "vachanas", :force => true do |t|
    t.integer  "vachanaid"
    t.string   "name"
    t.text     "vachana"
    t.integer  "vachanakaara_id"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.boolean  "reviewed",                          :default => false
    t.text     "meaning"
    t.string   "vachana_first_letter", :limit => 1
  end

  add_index "vachanas", ["vachana"], :name => "index_vachanas_on_vachana", :length => {"vachana"=>255}
  add_index "vachanas", ["vachana"], :name => "index_vachanas_on_vachana_fulltext"
  add_index "vachanas", ["vachana_first_letter"], :name => "index_vachanas_on_vachana_first_letter"
  add_index "vachanas", ["vachanaid"], :name => "index_vachanas_on_vachanaid"
  add_index "vachanas", ["vachanakaara_id"], :name => "index_vachanas_on_vachanakaara_id"

  create_table "word_lists", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "exact_search_count", :default => 0
    t.integer  "like_search_count",  :default => 0
  end

  add_index "word_lists", ["name"], :name => "index_word_lists_on_name"

end
