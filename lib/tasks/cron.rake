desc 'call this task periodically'
task :cron => ["messages:update", "messages:match"] do
  require File.dirname(__FILE__) + '/../../app/scripts/update'
end

namespace :messages do
  desc 'fetch email & parse them'
  task :fetch => :environment do
    require File.dirname(__FILE__) + '/../../app/scripts/get_posts'
  end

  desc 'match messages'
  task :match => :environment do
    require File.dirname(__FILE__) + '/../../app/scripts/matcher'
  end

  desc 'clear all pairs'
  task :clear => :environment do
    Post.update_all('pair_id = NULL')
  end
end
