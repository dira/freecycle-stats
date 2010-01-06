class Stat < ActiveRecord::Base
  def self.messages_per_kind
     data, labels, categories = [], [], []
     sorted_frequency = Post.count(:group => :category, :include => :category).map{|k, v| [k, v]}.sort{|a, b| b[1] <=> a[1]}
     sorted_frequency.each do |category, nr_messages|
       labels << (category.name rescue nil)
       data << nr_messages
       categories << category
     end
    { :data => data, :labels => labels, :categories => categories }
  end

  def self.messages_per_month(nr_months)
    messages_in_scope_per_month(nr_months, Post)
  end

  def self.messages_per_kind_per_month(category, nr_months)
    messages_in_scope_per_month(nr_months, Post.by_category_id(category.id))
  end

private
  def self.messages_in_scope_per_month(nr_months, posts)
    start_date = (nr_months - 1).months.ago.beginning_of_month.to_date
    end_date = 0.days.ago.end_of_month.to_date

    data = {}
    labels = []
    Post::KIND_MESSAGES.each{|kind| data[kind] = [] }

    while start_date < end_date
      labels << start_date

      raw = posts.count(
        :group  => "kind",
        :conditions => ["sent_date >= ? AND sent_date <= (?) AND kind IN (?)",
                        start_date, start_date.end_of_month, Post::KIND_MESSAGES])
      counts = {}
      raw.each{ |m| counts[m[0]] = m[1] }
      data.each{|kind, value| data[kind] << (counts[kind] || 0) }

      start_date = start_date.next_month
    end
    { :data => data, :labels => labels }
  end
end
