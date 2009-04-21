require 'md5'

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
    post[:subject_original] = subject_original
    return post
  end

  def self.offuscate_author(author)
    MD5.new(author).to_s
  end
end
