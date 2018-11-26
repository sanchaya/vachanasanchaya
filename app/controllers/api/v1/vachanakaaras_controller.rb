module Api
  module V1
    class VachanakaarasController < ApplicationController
      respond_to :json

      def index
        @vachanakaaras = Vachanakaara.limit(5)
      end

      def show
      vachanakaara_id = params[:id].to_i
      @vachanakaara = Vachanakaara.find(vachanakaara_id)
      @vachanas = @vachanakaara.vachanas.limit(5)
      end

    end
  end
end
