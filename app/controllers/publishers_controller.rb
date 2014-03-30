class PublishersController < ApplicationController

  def index
    @users =  User.includes(:role).where("roles.name = 'Publisher'")
    @reviewed_vachanas = ReviewVachana.where("published = ? or published IS NULL", false)
  end

  def show
    @reviewed_vachana = ReviewVachana.find(params[:id])
  end

  def create
   @reviewed_vachana = ReviewVachana.find(params[:reviewed_vachana])
   @reviewed_vachana.publish_vachana(current_user)
   flash[:notice] = "Published Successfully"
   redirect_to user_publishers_path(current_user)
 end

 def published_vachanas
  @published = ReviewVachana.where("published = ? and publisher_id = ?",true, current_user.id)
end

end
