class ReviewVachana < ActiveRecord::Base
  attr_accessible :review_vachana, :vachana_id, :review_vachanaid
 belongs_to :vachana
end
