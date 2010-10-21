class UpdateIgnoredPostKind < ActiveRecord::Migration
  def self.up
    Post.update_all("kind='admin'", { :kind => "ignored" })
  end

  def self.down
    Post.update_all("kind='ignored'", { :kind => "admin" })
  end
end
