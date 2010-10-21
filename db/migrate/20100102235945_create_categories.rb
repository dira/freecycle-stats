class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name

      t.timestamps
    end

    change_table :tag_candidates do |t|
      t.integer :category_id
    end
  end

  def self.down
    drop_table :categories
    change_table :tag_candidates do |t|
      remove_column :category_id
    end
  end
end
