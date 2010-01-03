class Category < ActiveRecord::Base
  has_many :tag_candidates

  validates_presence_of :name
end
