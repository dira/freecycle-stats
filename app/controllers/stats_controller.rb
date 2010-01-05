class StatsController < ApplicationController
  def index
    @global = Stat.messages_per_month(6)
    @global_per_kind = Stat.messages_per_kind
  end
end
