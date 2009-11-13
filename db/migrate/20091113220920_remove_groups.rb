class RemoveGroups < ActiveRecord::Migration
  def self.up
    drop_table :groups 
    remove_column :posts, :group_id
  end

  def self.down
    # can't undo
  end
end
