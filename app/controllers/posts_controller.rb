class PostsController < ApplicationController
  def index
    @offers =   Post.last_offers
    @requests = Post.last_requests
  end
end
