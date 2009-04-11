class AddGroupToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :group_id, :integer
  end

  def self.down
    remove_column :posts, :group_id
  end
end
