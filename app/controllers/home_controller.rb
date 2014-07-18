class HomeController < ApplicationController
  before_filter :authenticate_user_role! , only: [:admin_panel]
  def index
    @rand_vachana = DailyVachana.last 
    begin
      unless @rand_vachana and @rand_vachana.created_at.to_date == Date.today
       rand = Vachana.pluck(:id).sample
       while Vachana.find(rand).vachana.blank?
        rand = Vachana.pluck(:id).sample
      end
      @rand_vachana = DailyVachana.create vachana_id: rand
    end
  rescue => e
    p "ERRRORRRRRR"
    puts e
  end
  @vachana = @rand_vachana.vachana
end

def admin_panel
end

private

end
