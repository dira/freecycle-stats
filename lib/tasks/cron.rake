task :cron => :environment do
  require File.dirname(__FILE__) + '/../../app/scripts/update'
end

