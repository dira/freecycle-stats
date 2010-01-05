class AddCategoryProcessedToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :category_processed, :boolean, :default => false
  end

  def self.down
    remove_column :posts, :category_processed
  end
end
