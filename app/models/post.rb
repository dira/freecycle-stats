require 'md5'

class Post < ActiveRecord::Base
  belongs_to :group
  has_one :pair, :class_name => 'Post'

  KIND_PAIRS = [ 
    ["offer", "offer_completed"],
    ["request", "request_completed"]
  ]
  
  enum_field "kind", KIND_PAIRS.flatten + [ "ignore" ]

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
    # potential match
    return true if first.subject == second.subject
    return false
  end

  def set_pair(message)
    self.pair_id = message.id
    self.save!

    message.pair_id = self.id
    message.save!
  end
end
