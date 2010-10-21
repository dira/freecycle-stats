class StatsController < ApplicationController
  def index
    nr_months = 6
    Post.categorize_all
    @per_month = Stat.messages_per_month(nr_months)
    # @per_kind = Stat.messages_per_kind(nr_months)

    # @kinds_per_month = @per_kind[:categories].map do |category|
      # [category, Stat.messages_per_kind_per_month(category, nr_months)]
    # end
  end
end
