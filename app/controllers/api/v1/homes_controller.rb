module Api
  module V1
    class HomesController < ApplicationController
      respond_to :json
      
      def index
        @vachana = DailyVachana.last.vachana
      end

      def today_vachana
        @vachana = DailyVachana.last.vachana
      end
      
      
    end
  end
end