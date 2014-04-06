class WordListsController < ApplicationController
	load_and_authorize_resource
  def index
    @word_lists = WordList.all
  end

  def new
    @word_list = WordList.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @word_list }
    end
  end

  def create
    @word_list = WordList.new(params[:word_list])

    respond_to do |format|
      if @word_list.save
        format.html { redirect_to word_lists_path, notice: 'Word was successfully created.' }
        format.json { render json: @word_list, status: :created, location: @word_list }
      else
        format.html { render action: "new" }
        format.json { render json: @word_list.errors, status: :unprocessable_entity }
      end

    end
  end

  def download_keyword_csv
    @keywords = KeyWord.limit(20)
    send_data @keywords.to_csv

  end
end
