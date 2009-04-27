require 'md5'
require 'text'

class Post < ActiveRecord::Base
  belongs_to :group
  has_one :pair, :class_name => 'Post'

  KIND_PAIRS = [ 
    ["offer", "offer_completed"],
    ["request", "request_completed"]
  ]
  
  enum_field "kind", KIND_PAIRS.flatten + [ "ignore" ], :allow_nil => true

  def pair_id=(pid)
    pair = Post.find(pid)
    self[:pair_id] = pid
    self.save!
    pair[:pair_id] = self.id
    pair.save!
  end

  def self.kind_pair(kind)
    KIND_PAIRS.each do |p|
      if p.include?(kind)
        return p.select{ |k| k != kind }[0]
      end
    end
    return nil
  end

  def self.parse_subject(subject_original)
    post = {}
    subject = subject_original
    # remove [Freecycle Bucuresti] heading
    match = subject.match /^\[Freecycle [^\]]*\] (.*)/
    if match
      subject = match[1]
    end
    # have kind?
    kinds =
      {
        'ofer' => 'offer',
        'dat'  => 'offer_completed',
        'caut' => 'request',
        'luat' => 'request_completed'
      }

    expr = /\[?(caut|ofer|dat|luat)\]?\:?/i
    match = subject.match expr
    if (match)
      post[:kind] = kinds[match[1].downcase]
      subject[expr] = ''
    end
    post[:subject] = subject.strip
    post[:subject_original] = subject_original
    return post
  end

  def self.offuscate_author(author)
    MD5.new(author).to_s
  end

  def self.are_pair?(first, second)
    return false if Post.kind_pair(first.kind) != second.kind

    s1 = first.subject.downcase
    s2 = second.subject.downcase

    # equal
    return true if s1 == s2

    distance = Text::Levenshtein.distance(s1, s2)
    lengths = [s1.length, s2.length]
    sure_distance = lengths.max - lengths.min

    if distance - sure_distance < lengths.min / 5
      return true
    end

    return false
  end

  def set_pair(message)
    self.pair_id = message.id
  end
end
