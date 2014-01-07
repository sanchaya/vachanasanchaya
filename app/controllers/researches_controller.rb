class ResearchesController < ApplicationController
	def index
		params[:start_letter] = params[:start_letter] ? params[:start_letter] : "ಅ"
  		@keywords = KeyWord.start_letter(params[:start_letter]).order("count DESC").paginate(:page => params[:page], :per_page => 50)
  	respond_to do |format|
  		format.html
  format.js # actually means: if the client ask for js -> return file.js
end
	end
end
