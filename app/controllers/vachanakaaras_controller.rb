class VachanakaarasController < ApplicationController
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
  end

end
