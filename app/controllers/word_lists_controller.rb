class WordListsController < ApplicationController
	
	def index
		@word_lists = WordList.all
	end

	def new
		@word_list = WordList.new
	end
	def create
		@word_list = WordList.new(params[:word_list])
		if @word_list.save 
			flash[:notice] = "sucess"
			redirect_to word_lists_path
		else
			render "new"
		end
	end
end
