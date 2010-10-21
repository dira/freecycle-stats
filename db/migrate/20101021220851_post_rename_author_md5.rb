class PostRenameAuthorMd5 < ActiveRecord::Migration
  def self.up
    rename_column :posts, :author_md5, :author
  end

  def self.down
    rename_column :posts, :author, :author_md5
  end
end
