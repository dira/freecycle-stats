class GroupsController < ApplicationController
  def index
    @groups = Group.find(:all)
    redirect_to :controller => 'posts', :action => 'index', :group_id => @groups[0].to_param if !@groups.empty? && params[:home]
  end
end
