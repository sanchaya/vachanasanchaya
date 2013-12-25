class ResearchesController < ApplicationController
	def index
		params[:start_letter] = params[:start_letter] ? params[:start_letter] : "ಅ"
  		@keywords = KeyWord.start_letter(params[:start_letter])
  	respond_to do |format|
  		format.html
  format.js # actually means: if the client ask for js -> return file.js
end
	end
end
