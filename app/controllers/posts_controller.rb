class PostsController < ApplicationController
  before_filter :set_group

  def index
    @offers =   Post.last_offers
    @requests = Post.last_requests
  end

private
  def set_group
    @group = Group.first(params[:group_id])
  end
end
