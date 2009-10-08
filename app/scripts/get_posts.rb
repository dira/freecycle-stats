require 'net/imap'
require 'pp'

class MailHeaderFetcher
  LABEL_NEW = "#{RAILS_ENV}/new"
  LABEL_FETCHED = "#{RAILS_ENV}/fetched"

  def initialize(server, port, username, password)
    @imap = Net::IMAP.new(server, port, true)
    @imap.login(username, password)
  end
  
  def retrieve_messages
    @imap.select(LABEL_NEW)

    unfetched = @imap.uid_search("ALL")
    pp "#{unfetched.size} new messages"

    unfetched.each_slice(50) do |uids|
      to_move = []

      @imap.uid_fetch(uids, "ENVELOPE").each do |envelope|
        ok = yield envelope.attr["ENVELOPE"]
        to_move << envelope.attr["UID"] if ok
      end

      @imap.uid_copy(to_move, LABEL_FETCHED)
      @imap.uid_store(to_move, "+FLAGS", [:Deleted])
      flush
    end

    disconnect
  end

  def flush
    @imap.expunge
  end

  def disconnect
    @imap.logout()
    @imap.disconnect() rescue nil
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
    
    MailHeaderFetcher.new(server, port, username, password).retrieve_messages do |mail|
      begin
        hash = Post.parse_subject(mail.subject)
        hash[:group_id] = group.id
        hash[:message_id] = mail.message_id
        from = "#{mail.from[0].mailbox || mail.from[0].name}@#{mail.from[0].host}"
        hash[:author_md5] = Post.obfuscate_author(from)
        hash[:sent_date] = mail.date
        Post.find_or_create_by_message_id(hash)
        true
      rescue Error => err
        pp 'err', err,mail
        false
      end
    end
  end
end

