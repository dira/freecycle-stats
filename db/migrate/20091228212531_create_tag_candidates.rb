class CreateTagCandidates < ActiveRecord::Migration
  def self.up
    create_table :tag_candidates do |t|
      t.string :word
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :tag_candidates
  end
end
