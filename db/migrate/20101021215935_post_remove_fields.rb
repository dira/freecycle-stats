class PostRemoveFields < ActiveRecord::Migration
  def self.up
    remove_column :posts, :pair_id
    remove_column :posts, :category_id
    remove_column :posts, :category_processed
  end

  def self.down
    add_column :posts, :pair_id, :integer
    add_column :posts, :category_id, :integer
    add_column :posts, :category_processed, :boolean, :default => false
  end
end
