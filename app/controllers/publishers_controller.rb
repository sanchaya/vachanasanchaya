class PublishersController < ApplicationController
  authorize_resource :class => false
  def index
    @users =  User.includes(:role).where("roles.name = 'Publisher'")
    @reviewed_vachanas = ReviewVachana.where("published = ? or published IS NULL", false).order("review_vachanaid")
  end

  def show
    @reviewed_vachana = ReviewVachana.find(params[:id])
    unless @reviewed_vachana.published == true
      @vachana = @reviewed_vachana.vachana
      @comments = @reviewed_vachana.review_comments
      @reviewed_vachanas = ReviewVachana.where("published = ? or published IS NULL", false).order("review_vachanaid")
    else
      flash[:notice] = "This reviewed vachana already posted."
      redirect_to @reviewed_vachana.vachana
    end
  end

  def create
   @reviewed_vachana = ReviewVachana.find(params[:reviewed_vachana])
   @reviewed_vachana.review_comments.new(comment: params[:comment], user_id: current_user.id).save
   if params[:commit] == "reject-review"
    flash[:notice] = "Review rejected"
  else
   @reviewed_vachana.publish_vachana(current_user)
   flash[:notice] = "Published Successfully"
 end

 redirect_to user_publishers_path(current_user)
end

def published_vachanas
  @published = ReviewVachana.where("published = ? and publisher_id = ?",true, current_user.id)
end

end
