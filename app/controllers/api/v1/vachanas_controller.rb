module Api
  module V1
    class VachanasController < ApplicationController
      respond_to :json

      def index
        @vachanas = Vachana.limit(5)
      end

      def pada
        
      end

    end
  end
end