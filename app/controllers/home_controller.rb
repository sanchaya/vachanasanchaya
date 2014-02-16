class HomeController < ApplicationController

 def index
  @rand_vachana = DailyVachana.last 
  unless @rand_vachana and @rand_vachana.created_at.to_date == Date.today
    rand = Vachana.pluck(:id).sample
    @rand_vachana = DailyVachana.create vachana_id: rand
  end
  @vachana = @rand_vachana.vachana
end

end
