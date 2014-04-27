class ReviewVachanasController < ApplicationController
  load_and_authorize_resource
  def index
    if current_user.vachanakaaras.blank?
     flash[:notice] = "Sorry no vachanakaaras assigned to you."
     redirect_to :back
   else
    list_vachanakaara_vachanas
  end
end

def new

  @reviewer = current_user
  @vachana = Vachana.find(params[:vachana_id])
  reviewed_already = ReviewVachana.find_by_vachana_id(params[:vachana_id] )
  if reviewed_already
    redirect_to edit_user_review_vachana_path(@reviewer,reviewed_already) 
  else
    @review_vachana = ReviewVachana.new()
  end
  list_vachanakaara_vachanas

end

def create
  @reviewer = current_user
  @review_vachana = ReviewVachana.new(params[:review_vachana])
  @review_vachana.reviewer_id = @reviewer.id
  @review_vachana.reviewed = true
  if @review_vachana.save 
    @review_vachana.activity_owner = current_user
    flash[:notice] = "Vachana reviewed successfully"
    redirect_to user_review_vachanas_path(current_user) #edit_user_review_vachana_path(@reviewer,@review_vachana)
  else
    flash[:error] = "Vachana review failed! please try again"
    redirect_to user_review_vachanas_path(current_user)
  end
end

def edit
  @reviewer = current_user
  @review_vachana = ReviewVachana.find(params[:id])
  if @review_vachana.published == true 
    redirect_to vachana_path(@review_vachana.vachana.id)
  else
    @vachana = @review_vachana.vachana
  end
  list_vachanakaara_vachanas
end

def update
  @reviewer = current_user
  @review_vachana = ReviewVachana.find(params[:id])
  if @review_vachana.update_attributes(params[:review_vachana])
    flash[:notice] = "Vachana reviewed successfully"
    redirect_to user_review_vachanas_path(current_user) #edit_user_review_vachana_path(@reviewer,@review_vachana)
  end
end


def reviewed_vachanas
  @reviewed_vachanas = ReviewVachana.where(reviewer_id: current_user.id)
end

private

def list_vachanakaara_vachanas

  @vachanakaaras = current_user.vachanakaaras
  @published = ReviewVachana.where(reviewer_id: current_user.id, published: true).pluck("vachana_id")
  if (params[:user_vachanakaara] and !params[:user_vachanakaara].blank?) or @vachana
    @vachanakaara = @vachana ? @vachana.vachanakaara : Vachanakaara.find(params[:user_vachanakaara]) 
  else
    @vachanakaara = @vachanakaaras.first
  end
  @vachanas = @vachanakaara.vachanas.where("id not in (?)",  @published.blank? ? 0 : @published)
  @reviewed_vachanas = ReviewVachana.where(reviewer_id: current_user.id)
end

end
