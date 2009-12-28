class StatsController < ApplicationController
  def index
    @stats = Stat.messages_per_month(6)
  end
end
