class HomeController < ApplicationController
  def index
    @per_month_per_kind = Stat.per_month_per_kind(6)
  end
end
