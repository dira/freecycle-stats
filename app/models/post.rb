class Post < ActiveRecord::Base
  belongs_to :group
  enum_field "kind", [ "offer", "offer_completed", "request", "request_completed", "ignore" ]
end
