class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :author_md5
      t.date :sent_date
      t.string :message_id
      t.string :kind
      t.string :subject
      t.string :subject_original

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
