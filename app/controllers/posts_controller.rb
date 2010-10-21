class PostsController < ApplicationController
  def index
    @offers =   Post.last_offers
    @requests = Post.last_requests
  end

  def search
    redirect_to posts_path unless Post.initiator(params[:kind]) && params[:query].present?
    @results = Post.search(params[:query], params[:kind])
  end
end
