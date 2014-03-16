class ReviewVachanasController < ApplicationController
  def index
    @vachanakaaras = current_user.vachanakaaras
    if params[:user_vachanakaara] and !params[:user_vachanakaara].blank?
      @vachanas = Vachanakaara.find(params[:user_vachanakaara]).vachanas
    else
      @vachanas = @vachanakaaras.first.vachanas
    end
    
  end

  def new
  end
end
