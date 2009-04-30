require 'tmail'
require 'net/pop_ssl'
require 'pp'

class MailHeaderFetcher
  def initialize(server, port, username, password)
    @server, @port, @username, @password = server, port, username, password
  end
  
  def fetch_headers
    Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE)
    Net::POP3.start(@server, @port, @username, @password) do |pop|
      pop.mails.map { |pop_mail| TMail::Mail.parse(pop_mail.header) }
    end
  end
end

class GetPosts
  MAIL_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/mails.yml")
  server = MAIL_CONFIG['mail_server']['server']
  port = MAIL_CONFIG['mail_server']['port']

  Group.all.each do |group|
    pp "##{group.name}"

    username = MAIL_CONFIG[group.name]['username']
    password = MAIL_CONFIG[group.name]['password']
    
    mails = MailHeaderFetcher.new(server, port, username, password).fetch_headers
    pp "#{mails.size} mails"
    mails.each do |mail|
      hash = Post.parse_subject(mail.subject)
      hash[:group_id] = group.id
      hash[:message_id] = mail.message_id
      hash[:author_md5] = Post.obfuscate_author(mail.from[0])
      hash[:sent_date] = mail.date 
      Post.find_or_create_by_message_id(hash) 
    end
  end
end

