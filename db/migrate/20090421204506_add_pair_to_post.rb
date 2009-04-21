class AddPairToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :pair_id, :integer
  end

  def self.down
    remove_column :posts, :pair_id
  end
end
