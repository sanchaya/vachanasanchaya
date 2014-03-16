class ReviewVachanasController < ApplicationController
def index
  if current_user.vachanakaaras.blank?
   flash[:notice] = "Sorry no vachanakaaras assigned to you."
   redirect_to :back
 else
  @vachanakaaras = current_user.vachanakaaras
  if params[:user_vachanakaara] and !params[:user_vachanakaara].blank?
    @vachanas = Vachanakaara.find(params[:user_vachanakaara]).vachanas
  else
    @vachanas = @vachanakaaras.first.vachanas
  end
end
end

def new
end

end
