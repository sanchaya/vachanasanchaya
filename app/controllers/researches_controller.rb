class ResearchesController < ApplicationController
	def index
		if params[:start_letter]
  		@keywords = KeyWord.start_letter(params[:start_letter])
  	else
  		params[:start_letter] = "ಅ"
  		@keywords = KeyWord.start_letter(params[:start_letter])
  	end

  	respond_to do |format|
  		format.html
  format.js # actually means: if the client ask for js -> return file.js
end
	end
end
