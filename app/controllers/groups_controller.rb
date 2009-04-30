class GroupsController < ApplicationController
  def index
    @groups = Group.find(:all)
    redirect_to group_posts_path(@groups[0].to_param) if @groups.size == 1
  end
end
