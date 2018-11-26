class ReviewComment < ActiveRecord::Base
  attr_accessible :comment, :user_id

  belongs_to :user
  belongs_to :review_vachana
end
