class Admin::TagCandidatesController < Admin::AdminController
  layout proc{ |c| c.request.xhr? ? false : "admin" }

  def index
    @candidates = TagCandidate::candidates
  end

  def create
    tag = TagCandidate.create(params[:tag_candidate])
    render :text => tag.valid? 
  end

  def disable_all
    params[:words].split(',').each do |word|
      TagCandidate.create(:word => word, :status => "no") 
    end
    redirect_to admin_tag_candidates_path
  end
end
