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
  
  context 'setup from scraping:' do
    [
      {:subject_original => "[Freecycle Bucuresti] OFER: frigider vechi", :kind => 'offer', :subject => "frigider vechi"},
      {:subject_original => "[Freecycle Bucuresti] CAUT: blender", :kind => 'request', :subject => "blender"},
      {:subject_original => "[Freecycle Bucuresti] DAT: Stephen King", :kind => "offer_completed", :subject => "Stephen King"},
      {:subject_original => "[Freecycle Bucuresti] LUAT: carcasa miniATX", :kind => "request_completed", :subject => "carcasa miniATX"},
      {:subject_original => "CAUT: Cablu acceleratie Dacia Break 1410 din 1997", :kind => 'request', :subject => "Cablu acceleratie Dacia Break 1410 din 1997"},
      {:subject_original => "[OFER] monitor de 20\" HP M900 functional", :kind => "offer", :subject => "monitor de 20\" HP M900 functional"},
      {:subject_original => "carti", :kind => nil, :subject => "carti"},
    ].each do |test|
      context "parse \"#{test[:subject_original]}\"" do
        setup do
          @post = Post.parse_subject(test[:subject_original])
        end
        should "get subject right" do
          assert_equal test[:subject], @post[:subject]
        end
        should "get kind right" do
          assert_equal test[:kind], @post[:kind]
        end
      end
    end
  end
end
