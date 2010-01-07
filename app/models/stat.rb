class Stat < ActiveRecord::Base
  def self.messages_per_kind(nr_months)
     data, labels, categories = [], [], []
     period = period(nr_months)
     sorted_frequency = Post.count(:group => :category, :include => :category,
       :conditions => ["sent_date >= ? AND sent_date <= (?)", period[0], period[1]] ).sort{|a, b| b[1] <=> a[1]}
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
    messages_in_scope_per_month(nr_months, Post.by_category_id((category.id rescue nil)))
  end

private
  def self.period(last_x_months)
    [last_x_months.months.ago.beginning_of_month.to_date, 1.month.ago.end_of_month.to_date]
  end

  def self.messages_in_scope_per_month(nr_months, posts)
    period = period(nr_months)
    start_date = period[0]

    data = {}
    labels = []
    Post::KIND_MESSAGES.each{|kind| data[kind] = [] }

    while start_date < period[1]
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
