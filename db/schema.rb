# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090421204506) do

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "web"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mails", :force => true do |t|
    t.string   "message_id"
    t.string   "subject_original"
    t.string   "subject"
    t.string   "kind"
    t.string   "from"
    t.string   "to"
    t.string   "date"
    t.string   "match_message_id"
    t.integer  "match_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mails_backup", :force => true do |t|
    t.string   "message_id"
    t.string   "subject_original"
    t.string   "subject"
    t.string   "kind"
    t.string   "from"
    t.string   "to"
    t.string   "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mails_old", :force => true do |t|
    t.string   "message_id"
    t.string   "subject_original"
    t.string   "subject"
    t.string   "kind"
    t.string   "from"
    t.string   "to"
    t.string   "date"
    t.string   "match_message_id"
    t.integer  "match_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mails_old_backup", :force => true do |t|
    t.string   "message_id"
    t.string   "subject_original"
    t.string   "subject"
    t.string   "kind"
    t.string   "from"
    t.string   "to"
    t.string   "date"
    t.string   "match_message_id"
    t.integer  "match_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.string   "author_md5"
    t.date     "sent_date"
    t.string   "message_id"
    t.string   "kind"
    t.string   "subject"
    t.string   "subject_original"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.integer  "pair_id"
  end

  create_table "posts_backup", :force => true do |t|
    t.string   "author_md5"
    t.date     "sent_date"
    t.string   "message_id"
    t.string   "kind"
    t.string   "subject"
    t.string   "subject_original"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
  end

  create_table "posts_backup2", :force => true do |t|
    t.string   "author_md5"
    t.date     "sent_date"
    t.string   "message_id"
    t.string   "kind"
    t.string   "subject"
    t.string   "subject_original"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
  end

  create_table "posts_backup3", :force => true do |t|
    t.string   "author_md5"
    t.date     "sent_date"
    t.string   "message_id"
    t.string   "kind"
    t.string   "subject"
    t.string   "subject_original"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
  end

end
