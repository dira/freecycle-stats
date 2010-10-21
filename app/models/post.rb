require 'md5'
require 'text'

class Post < ActiveRecord::Base
  before_create :obfuscate_author

  MESSAGE_KINDS_TO_KEYWORDS = {
    'offer'             => ['ofer', 'dau'],
    'offer_completed'   => 'dat',
    'request'           => 'caut',
    'request_completed' => 'luat',
  }
  KINDS_TO_KEYWORDS = MESSAGE_KINDS_TO_KEYWORDS.merge({ 'admin' => 'admin' })

  enum_field 'kind', KINDS_TO_KEYWORDS.keys + ['unknown']

  def self.create_from_mail(mail)
    hash = Post.parse_subject(mail.subject)
    hash[:message_id] = mail.message_id
    hash[:author] = "#{mail.from[0].mailbox || mail.from[0].name}@#{mail.from[0].host}"
    hash[:sent_date] = mail.date

    Post.find_or_create_by_message_id(hash)
  rescue StandardError => err
    p 'Error:', err, mail
    nil
  end

  protected
    def obfuscate_author
      self.author = MD5.new(author).to_s
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
      expr = /\[?(#{KINDS_TO_KEYWORDS.values.flatten.join('|')})\]?(\:|\s)/i
      match = subject.match expr
      if (match)
        value = match[1].downcase
        post[:kind] = KINDS_TO_KEYWORDS.select{|k,v| v.include?(value)}.first[0]
        subject[expr] = ''
      else
        post[:kind] = 'unknown'
      end
      post[:subject] = subject.strip
      post[:subject_original] = subject_original
      post
    end
end
