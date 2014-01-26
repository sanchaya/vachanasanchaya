class DailyVachana < ActiveRecord::Base
  attr_accessible :vachana_id, :created_at
  belongs_to :vachana
end
