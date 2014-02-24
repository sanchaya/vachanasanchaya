class GlossariesController < ApplicationController

  def index
    @words = Glossary.order("word").limit(100)
  end
  def destroy
    @glossary = Glossary.find(params[:id])
    @glossary.destroy
    redirect_to glossaries_path
  end
end
