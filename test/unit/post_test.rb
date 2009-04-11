require File.dirname(__FILE__) + '/../test_helper'

class PostTest < ActiveSupport::TestCase
  should_have_db_column :author_md5
  should_have_db_column :sent_date
  should_have_db_column :message_id
  should_have_db_column :kind
  should_allow_values_for :kind, 'offer', 'offer_completed', 'request', 'request_completed', 'ignore' 
  should_not_allow_values_for :kind, 'other', :message => "is invalid"
  should_have_db_column :subject
  should_have_db_column :subject_original
  
  should_belong_to :group
  
end
