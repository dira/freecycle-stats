class PostsController < ApplicationController
  before_filter :set_group

  def index
    limit = 25
    options = {
      :limit => limit, :order => "sent_date DESC"
    }
    @offers = @group.posts.all(options.merge( {:conditions => { :kind => 'offer' } }))
    @requests = @group.posts.all(options.merge( {:conditions => { :kind => 'request' } }))
  end

private
  def set_group
    @group = Group.first(params[:group_id])
  end
end
