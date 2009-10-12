require File.dirname(__FILE__) + '/../test_helper'

class PostTest < ActiveSupport::TestCase
  should_have_db_column :author_md5
  should_have_db_column :sent_date
  should_have_db_column :message_id
  should_have_db_column :kind
  should_have_db_column :subject
  should_have_db_column :subject_original

  should_allow_values_for :kind, 'offer', 'offer_completed', 'request', 'request_completed', 'admin'
  should_not_allow_values_for :kind, 'other', :message => "is invalid"
  
  should_belong_to :group
  # should_have_one :pair # TODO not working
  
context 'setup from scraping:' do
  [
    #standard
    {:subject_original => "[Freecycle Bucuresti] OFER: frigider vechi", :kind => 'offer', :subject => "frigider vechi"},
    {:subject_original => "[Freecycle Bucuresti] CAUT: blender", :kind => 'request', :subject => "blender"},
    {:subject_original => "[Freecycle Bucuresti] DAT: Stephen King", :kind => "offer_completed", :subject => "Stephen King"},
    {:subject_original => "[Freecycle Bucuresti] LUAT: carcasa miniATX", :kind => "request_completed", :subject => "carcasa miniATX"},
    #without the group part
    {:subject_original => "CAUT: Cablu acceleratie Dacia Break 1410 din 1997", :kind => 'request', :subject => "Cablu acceleratie Dacia Break 1410 din 1997"},
    {:subject_original => "[OFER] monitor de 20\" HP M900 functional", :kind => "offer", :subject => "monitor de 20\" HP M900 functional"},
    #with different verb for offers, different case and punctuation
    {:subject_original => "DAU: monitor", :kind => "offer", :subject => "monitor"},
    {:subject_original => "DAU monitor", :kind => "offer", :subject => "monitor"},
    {:subject_original => "Dau monitor", :kind => "offer", :subject => "monitor"},
    {:subject_original => "dau monitor", :kind => "offer", :subject => "monitor"},

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

  should 'allow nil for kind' do
    post = Post.new()
    post.valid? # trigger check
    assert_equal nil, post.errors['kind']
  end

  should 'obfuscate author' do
    # TODO factory not working, why oh why
    post = Post.new(:author_md5 => 'gigi', :kind => 'request')
    initial_author = post.author_md5
    assert_not_equal initial_author, Post.obfuscate_author(post.author_md5)
  end
end

context 'kinds' do
  [
    ['offer', 'offer_completed'],
    ['offer_completed', 'offer'],
    ['request', 'request_completed'],
    ['request_completed', 'request'],
    ['asd', nil]
  ].each do | kind, answer |
    should "get right pair for: #{kind}" do
      assert_equal answer, Post.kind_pair(kind)
    end
  end
end

context 'update pair_id' do
    setup do
      # TODO factory not working, why oh why
      @post1 = Post.new(:author_md5 => 'gigi', :kind => 'request')
      @post1.save!
      @post2 = Post.new(:author_md5 => 'gigi', :kind => 'request')
      @post2.save!

      @post1.pair_id = @post2.id
    end
    should 'update pair id for the other post' do
      assert_equal @post2.id, Post.find(@post1.id).pair_id
      assert_equal @post1.id, Post.find(@post2.id).pair_id
    end
end


end
