class Stat < ActiveRecord::Base
  def self.messages_per_month(nr_months)
    start_date = (nr_months - 1).months.ago.beginning_of_month.to_date
    end_date = 0.days.ago.end_of_month.to_date

    data = {}
    labels = []
    Post::KIND_MESSAGES.each{|kind| data[kind] = [] }

    while start_date < end_date
      labels << start_date

      raw = Post.count(
        :group  => "kind",
        :conditions => ["sent_date >= ? AND sent_date <= (?) AND kind IN (?)", 
                        start_date, start_date.end_of_month, Post::KIND_MESSAGES])
      counts = {}
      raw.each{ |m| counts[m[0]] = m[1] }
      data.each{|kind, value| data[kind] << counts[kind] }
      
      start_date = start_date.next_month
    end
    
    { :data => data, :labels => labels }
  end
end
