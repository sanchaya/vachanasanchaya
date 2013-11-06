class VachanakaarasController < ApplicationController
  def index
  	@vachanakaaras = Vachanakaara.all
  end

  def show
  	@vachanakaara = Vachanakaara.find(params[:id])
  	@vachanas = @vachanakaara.vachanas
  end

end
