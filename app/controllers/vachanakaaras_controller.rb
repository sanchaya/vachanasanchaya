class VachanakaarasController < ApplicationController
 before_filter :authenticate_user_role! , only: [:new, :edit,:create,:update,:destroy]
 def index
  	# @vachanakaaras = Vachanakaara.all
    params[:start_letter] = params[:start_letter] ? params[:start_letter] : "ಅ"
    @vachanakaaras= Vachanakaara.start_letter(params[:start_letter])

    respond_to do |format|
      format.html
  format.js # actually means: if the client ask for js -> return file.js
end
end

def show
 @vachanakaara = Vachanakaara.find(params[:id])
 @vachanas = @vachanakaara.vachanas

 params[:start_letter] = params[:start_letter] ? params[:start_letter] : "ಅ"
 @vachanas= @vachanas.start_letter(params[:start_letter]).paginate(:page => params[:page], :per_page => 25)
 respond_to do |format|
  format.html
  format.js # actually means: if the client ask for js -> return file.js
end
end


def edit
  @vachanakaaras = Vachanakaara.order("name")
  @vachanakaara = Vachanakaara.find params[:id]
end

def update
  @vachanakaara =  Vachanakaara.find params[:id]
  @vachanakaara.update_attributes params[:vachanakaara]
  redirect_to edit_vachanakaara_path @vachanakaara
end

def search_vachanakaara_name
  @vachanakaaras = Vachanakaara.name_like params[:vachanakaara_name]

end

end
