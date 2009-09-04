class PostsController < ApplicationController
  before_filter :set_group

  def index
    @offers = Post.recent_offers
    @requests = Post.recent_requests
  end

private
  def set_group
    @group = Group.first(params[:group_id])
  end
end
