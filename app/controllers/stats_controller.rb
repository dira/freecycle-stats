class StatsController < ApplicationController
  def index
    Post.categorize_all
    @per_month = Stat.messages_per_month(6)
    @per_kind = Stat.messages_per_kind

    @kinds_per_month = @per_kind[:categories].map do |category|
      [category, Stat.messages_per_kind_per_month(category, 6)]
    end
  end
end
