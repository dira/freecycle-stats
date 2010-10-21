class Category < ActiveRecord::Base
  has_many :tag_candidates, :conditions => 'status = "yes"'

  validates_presence_of :name
end
