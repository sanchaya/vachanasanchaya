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
  @vachanakaara = params[:vachanakaara_name].to_s
  @ankitha_naama = params[:ankitha_naama].to_s
  if @vachanakaara.blank? and @ankitha_naama.blank?
    flash[:notice] = "ನೀವು ಯಾವುದೇ ಆಯ್ಕೆ ಮಾಡಿರುವುದಿಲ್ಲ"
    redirect_to :back
  else
    if @vachanakaara.blank?
      @vachanakaaras = Vachanakaara.ankitha_like  @ankitha_naama
    elsif @ankitha_naama.blank?
      @vachanakaaras = Vachanakaara.name_like  @vachanakaara
    else
      @vachanakaaras = Vachanakaara.name_or_ankitha_like  @vachanakaara,@ankitha_naama
    end
  end

end

def download_vachanakaara_csv
  require 'csv'
  @vachanakaaras = Vachanakaara.order("name")
  send_data(
    @vachanakaaras.to_csv,
    :type => 'text/csv',
    :filename => 'KeyWord.csv',
    :disposition => 'attachment'
    )
end

def download_akkamahadevi_vachana_csv
  require 'csv'
 
  send_data(
    Vachana.to_csv,
    :type => 'text/csv',
    :filename => 'KeyWord.csv',
    :disposition => 'attachment'
    )
end

end
