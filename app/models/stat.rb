class Stat < ActiveRecord::Base
  def self.per_month_per_kind(nr_months)
    messages_in_scope_per_month(nr_months, Post)
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
    Post::MESSAGE_KINDS_TO_KEYWORDS.keys.each{|kind| data[kind] = [] }

    while start_date < period[1]
      labels << start_date

      counts = posts.group(:kind).where(["sent_date >= ? AND sent_date <= (?) AND kind IN (?)",
                        start_date, start_date.end_of_month, Post::MESSAGE_KINDS_TO_KEYWORDS.keys]).count
      data.each{|kind, value| data[kind] << (counts[kind] || 0) }

      start_date = start_date.next_month
    end
    { :data => data, :labels => labels }
  end
end
