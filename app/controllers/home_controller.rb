class HomeController < ApplicationController
  def index
    @per_month_per_kind = Stat.per_month_per_kind(6)
    @offers   = Post.order("sent_date desc").limit(5).where(:kind => 'offer')
    @requests = Post.order("sent_date desc").limit(5).where(:kind => 'request')
  end
end
