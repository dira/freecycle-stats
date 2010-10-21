class Admin::TagCandidatesController < Admin::AdminController
  layout proc{ |c| c.request.xhr? ? false : "admin" }

  def index
    @tags = TagCandidate.tags.uncategorized.limited(30)
    @categories = Category.all(:order => :name)
  end

  def filter_words
    @candidates = TagCandidate::candidates
  end

  def create
    tag = TagCandidate.create(params[:tag_candidate])
    render :text => tag.valid? 
  end

  def update
    tag = TagCandidate.find(params[:id])
    tag.update_attributes!(params[:tag_candidate])
    render :text => ""
  end

  def destroy
    TagCandidate.find(params[:id]).delete
    render :text => ""
  end

  def disable_all
    params[:words].split(',').each do |word|
      TagCandidate.create(:word => word, :status => "no") 
    end
    redirect_to filter_words_admin_tag_candidates_path
  end
end
