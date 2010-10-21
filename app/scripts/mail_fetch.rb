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
  def self.fetch
    config = YAML.load_file("#{Rails.root.to_s}/config/mails.yml")

    MailFetcher.new(config['mail_server']).retrieve_messages do |mail|
      Post.create_from_mail(mail)
    end
  end
end
