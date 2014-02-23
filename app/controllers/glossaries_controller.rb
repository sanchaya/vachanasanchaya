class GlossariesController < ApplicationController

  def index
    @words = Glossary.order("word").limit(100)
  end

end
