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
    assert Post.similarity('ghete noi', base) > Post.similarity('ghete fara sireturi', base)
  end

  should 'ignore what is in paranthesys' do
    assert_equal 1, Post.similarity('ghete (zona Floreasca)', 'ghete')
  end

  [
    ['ghete noi', 'papuci'],
    ['ghete fara sireturi noi', 'papuci fara talpa']
  ].each do |s1, s2|
    should "not recognize #{s1} and #{s2}" do
      assert_equal 0, Post.similarity(s1, s2)
    end
  end

  [
    ["sterilizator si huda izoterma biberoane",
     "sterilizator biberoane pt cuptorul cu microunde si o husa termica"],

    ["scaner fara cabluri",
    "scaner [3 Attachments]"],

    ["carticica pt mamica si cursuri mkt",
    "brosura pentru viitoare mamici (in Franceza) si cursuri (marketing&PR&publ)"],

    ["monitor functional DELL",
    "monitor Dell [1 Attachment]"],

    ["derulator de casete video si boxa",
    "difuzor si derulator de casete video"],

    ["Monitor 17 inch (care tiuie)",
    "Monitor tiuitor"],

    ["carti si manuale de scoala",
    "manuale si carti de scoala"],

    ["cedat: abonament internet mobile Vodafone",
    "Cedez abonament mobile Internet VDF"],

    ["Dulap vechi an 1900",
     "dulap vechi, 1900, prafuit si fara placa de marmura"],

    ["Aragaz 4 ochiuri si cuptor",
    "Aragaz cu patru ochiuri in Berceni"],

    ["2 Palete Badminton, 2 Rachete Tenis, o parte din carti vechi",
    "Carti Vechi, 2 Palete Badminton, 2 Rachete Tenis"],

    ["colectie Top Gun (revista de aviatie)",
    "reviste Top Gun (750)"]
  ].each do |s1, s2|
    should "recognize #{s1} and #{s2} as similar" do
      assert Post.similarity(s1, s2)
    end
  end
end
end
