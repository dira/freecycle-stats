require 'md5'
require 'text'

class Post < ActiveRecord::Base
  belongs_to :group
  has_one :pair, :class_name => 'Post'

  KIND_PAIRS = [ 
    ["offer", "offer_completed"],
    ["request", "request_completed"]
  ]
  KIND_OTHERS = ["admin"]

  KINDS = KIND_OTHERS + KIND_PAIRS.flatten
  enum_field "kind", KINDS, :allow_nil => true

  named_scope :last_offers,   :conditions => { :kind => "offer" },   :limit => 25, :order => "sent_date DESC"
  named_scope :last_requests, :conditions => { :kind => "request" }, :limit => 25, :order => "sent_date DESC"

  named_scope :without_pair, :conditions => { :pair_id => nil }
  named_scope :without_kind, :conditions => { :kind => nil }

  named_scope :sent_before, lambda{ |post| { :conditions => ["sent_date <= ?", post.sent_date] } }

  def set_pair(message)
    self.pair_id = message.id
  end

  def pair_id=(pid)
    if pid
      pair = Post.find(pid)
      self[:pair_id] = pid
      self.save!
      pair[:pair_id] = self.id
      pair.save!
    else
      if self[:pair_id]
        pair = Post.find(self[:pair_id])
        pair[:pair_id] = nil
        pair.save!
      end
      self[:pair_id] = nil
      self.save!
    end
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
    kinds = {
      'admin'             => 'admin',
      'offer'             => ['ofer', 'dau'],
      'offer_completed'   => 'dat',
      'request'           => 'caut',
      'request_completed' =>'luat'
    }

    expr = /\[?(#{kinds.values.flatten.join('|')})\]?(\:|\s)/i
    match = subject.match expr
    if (match)
      value = match[1].downcase
      post[:kind] = kinds.select{|k,v| v.include?(value)}.first[0]
      subject[expr] = ''
    end
    post[:subject] = subject.strip
    post[:subject_original] = subject_original
    return post
  end

  def self.obfuscate_author(author)
    MD5.new(author).to_s
  end

  def self.are_pair?(first, second)
    return false if Post.kind_pair(first.kind) != second.kind
    subject_matches?(first, second)
  end

  def self.subject_matches?(first, second)
    s1 = first.subject.downcase
    s2 = second.subject.downcase

    # equal
    return true if s1 == s2

    distance = Text::Levenshtein.distance(s1, s2)
    lengths = [s1.length, s2.length]
    sure_distance = lengths.max - lengths.min

    return distance - sure_distance < lengths.min / 5
  end

  def self.unmatched_confirmations
    Post.without_pair.all(
      :conditions => { :kind => ["request_completed", "offer_completed"] },
      :order => "sent_date DESC"
    )
  end

  def self.search_unmatched(term, post)
    results = Post.without_pair
    results = results.sent_before(post) if post
    results = results.all(
      :conditions => ['subject LIKE ? ', "%#{term}%"],
      :order => "sent_date DESC"
    )
    results.delete(post) if post
    results
  end

  def self.candidates_same_author(post)
    Post.without_pair.sent_before(post).all(
      :conditions => { :author_md5 => post.author_md5 },
      :order => "sent_date DESC"
    ).select{|p| p != post}
  end

  def self.candidates_same_text(post)
    Post.without_pair.sent_before(post).all(
      :conditions => ["sent_date<=? AND sent_date>=?", post.sent_date, post.sent_date - 30.days],
      :order => "sent_date DESC"
    ).select{|candidate| subject_matches?(post, candidate)}.select{|p| p != post}
  end

end
