class HomeController < ApplicationController
  def index
    redirect_to stats_path
  end
end
