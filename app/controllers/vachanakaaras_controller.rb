class VachanakaarasController < ApplicationController
  def index
  	# @vachanakaaras = Vachanakaara.all
  	if params[:start_letter]
  		@vachanakaaras= Vachanakaara.start_letter(params[:start_letter])
  	end

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
