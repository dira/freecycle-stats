class RemoveAdministration < ActiveRecord::Migration
  def self.up
    drop_table :categories
    drop_table :identity_urls
    drop_table :open_id_authentication_associations
    drop_table :open_id_authentication_nonces
    drop_table :tag_candidates
    drop_table :users
  end

  def self.down
    create_table "categories", :force => true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "identity_urls", :force => true do |t|
      t.integer  "user_id"
      t.string   "url",        :limit => 100
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "identity_urls", ["url"], :name => "index_identity_urls_on_url", :unique => true

    create_table "open_id_authentication_associations", :force => true do |t|
      t.integer "issued"
      t.integer "lifetime"
      t.string  "handle"
      t.string  "assoc_type"
      t.binary  "server_url"
      t.binary  "secret"
    end

    create_table "open_id_authentication_nonces", :force => true do |t|
      t.integer "timestamp",  :null => false
      t.string  "server_url"
      t.string  "salt",       :null => false
    end

    create_table "tag_candidates", :force => true do |t|
      t.string   "word"
      t.string   "status"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "category_id"
    end

    create_table "users", :force => true do |t|
      t.string   "nickname"
      t.string   "email"
      t.string   "remember_token",            :limit => 40
      t.datetime "remember_token_expires_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
