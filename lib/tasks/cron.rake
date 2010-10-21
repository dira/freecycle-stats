desc 'call this task periodically'
task :cron => ["messages:fetch"] do
end

namespace :messages do
  desc 'fetch emails & parse them'
  task :fetch => :environment do
    require File.dirname(__FILE__) + '/../../app/scripts/mail_fetch'
    Fetcher.fetch
  end
end
