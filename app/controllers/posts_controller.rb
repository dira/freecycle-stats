class PostsController < ApplicationController
  before_filter :set_group

  def index
    @offers = Post.offers.recent.recent_first
    @requests = Post.requests.recent.recent_first
  end

private
  def set_group
    @group = Group.first(params[:group_id])
  end
end
