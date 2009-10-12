require File.dirname(__FILE__) + '/../test_helper'

class MatchingTest < ActiveSupport::TestCase

context 'simplify' do
  should 'remove paranthesys' do
    assert_equal('ghete', Post.simplify_subject('ghete (Rahova, Bucuresti)'))
  end
end

context 'matching should be weighted' do
  should 'identical - 100%' do
    assert_equal 1, Post.similarity('test', 'test')
  end

  should 'give better score for better matches' do
    base = 'dulap cu 2 usi'
    assert Post.similarity('dulap cu 4 usi', base) > Post.similarity('dulap', base)
  end

  should "give better score for match closer to the base's length" do
    base = 'ghete'
    assert Post.similarity('ghete noi', base) > Post.similarity('ghete cu funda', base)
  end

  should "return false for no match" do
    assert_equal false, Post.similarity('ghete noi', 'papuci')
  end

  should 'ignore what is in paranthesys' do
    assert_equal 1, Post.similarity('ghete (zona Floreasca)', 'ghete')
  end
end

end
