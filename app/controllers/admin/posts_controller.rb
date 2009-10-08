class Admin::PostsController < ApplicationController
  layout "admin"
  before_filter :login_required
  before_filter :get_post, :only => [ :show, :update, :search ]

  def index
    @unknown_kind = Post.without_kind
    @unmatched    = Post.unmatched_confirmations
  end

  def show
    @candidates = {
      :same_author  => Post.candidates_same_author(@post),
      :same_text    => Post.candidates_same_text(@post)
    }
  end

  def update
    @post.update_attributes(params[:post])
    redirect_to :action => 'index'
  end

  def search
    @search_results = Post.search_unmatched(params[:term], @post)
    show
    render :show
  end
  
private
  def get_post
    @post = Post.find(params[:id])
  end
end
