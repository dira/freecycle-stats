require 'net/imap'

class MailFetcher
  NEW     = "#{Rails.env}/new"
  FETCHED = "#{Rails.env}/fetched"

  def initialize(config)
    @imap = Net::IMAP.new(config['server'], config['port'], true)
    @imap.login(config['username'], config['password'])
  end

  def retrieve_messages
    @imap.select(NEW)

    unfetched = @imap.uid_search("ALL")
    p "#{unfetched.size} new messages"

    unfetched.each_slice(50) do |uids|
      to_move = []

      @imap.uid_fetch(uids, "ENVELOPE").each do |envelope|
        ok = yield envelope.attr["ENVELOPE"]
        to_move << envelope.attr["UID"] if ok
      end

      @imap.uid_copy(to_move, FETCHED)
      @imap.uid_store(to_move, "+FLAGS", [:Deleted])
      flush

      p '.'
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

class Fetcher
  def self.create_post(mail)
    hash = Post.parse_subject(mail.subject)
    hash[:message_id] = mail.message_id
    from = "#{mail.from[0].mailbox || mail.from[0].name}@#{mail.from[0].host}"
    hash[:author_md5] = Post.obfuscate_author(from)
    hash[:sent_date] = mail.date

    Post.find_or_create_by_message_id(hash)
    true
  rescue Error => err
    p 'Error:', err, mail
    false
  end

  def self.fetch
    config = YAML.load_file("#{Rails.root.to_s}/config/mails.yml")

    MailFetcher.new(config['mail_server']).retrieve_messages do |mail|
      MailFetcher.create_post(mail)
    end
  end
end
