class StatsController < ApplicationController
  def index
    Post.categorize_all
    @global_per_month = Stat.messages_per_month(6)
    @global_per_kind = Stat.messages_per_kind

    @kinds_per_month = @global_per_kind[:categories][0..2].map do |category|
      [category, Stat.messages_per_kind_per_month(category, 6)]
    end
  end
end
