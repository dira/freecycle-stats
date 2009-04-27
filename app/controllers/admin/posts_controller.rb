class Admin::PostsController < ApplicationController
  layout "admin"
  before_filter :login_required
  before_filter :get_post, :only => [ :show, :update, :search ]

  POSTS_FROM = 30.days.ago

  def index
    @unknown_kind = unknown_kind
    @unmatched = unmatched
  end

  def unknown_kind
    @posts = Post.all(:conditions => { :kind => nil} )
    filter(@posts)
  end

  def unmatched
    @posts = Post.all(:conditions => { :pair_id => nil, :kind => ["request_completed", "offer_completed"] }, :order => "sent_date DESC" )
    filter(@posts)
  end

  def show
    # show all messages from the same author
    @candidates = Post.all(:conditions => { :author_md5 => @post.author_md5, :pair_id => nil })
    @candidates = filter_current(@candidates, @post)
  end

  def update
    @post.update_attributes(params[:post])
    redirect_to :action => 'index'
  end

  def search
    @term = params[:term]
    @search_results = Post.all(:conditions => ['subject LIKE ? AND pair_id IS NULL', "%#{@term}%"])
    @search_results = filter_current(@search_results, @post)

    show
    render :action => :show
  end
  
private
  def filter(posts)
    posts.select{ |p| p.sent_date.to_datetime > POSTS_FROM }
  end

  def filter_current(posts, post)
    posts.select{ |p| p != post }
  end

  def get_post
    @post = Post.find(params[:id])
  end
end
