class Post < ActiveRecord::Base
  belongs_to :group
  enum_field "kind", [ "offer", "offer_completed", "request", "request_completed", "ignore" ]

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
    return post
  end

  def self.offuscate_author(post)
    require 'md5'
    post.author_md5 = MD5.new(post.author_md5)
    post.save
  end
end
