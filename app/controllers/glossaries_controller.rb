class GlossariesController < ApplicationController

  def index
    # @words = Glossary.order("word").limit(100)
  end
  # def destroy
  #   @glossary = Glossary.find(params[:id])
  #   @glossary.destroy
  #   redirect_to glossaries_path
  # end

  def search 
    @word = params[:word].to_s
    @words = Glossary.words_like(@word)
  end

end
