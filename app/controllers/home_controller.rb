class HomeController < ApplicationController
  def index
    redirect_to posts_path
  end
end
