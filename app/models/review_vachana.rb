class ReviewVachana < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  
  attr_accessible :review_vachana, :vachana_id, :review_vachanaid
  belongs_to :vachana
  belongs_to :user, foreign_key: :reviewer_id

  def publish_vachana publisher
    old= OldVachana.new(vachana_id: self.vachana.id, old_vachana: self.vachana.vachana, old_vachanaid: self.vachana.vachanaid, old_name: self.vachana.name, reviewer_id: self.reviewer_id, publisher_id: publisher.id)
    if old.save
      self.vachana.update_attributes(vachana: self.review_vachana, vachanaid: self.review_vachanaid, name: self.review_name)
      self.published = true 
      self.publisher_id = publisher.id
      self.save
      return true
    else
      return false
    end
  end

  def is_published?
    self.published == true
  end

end
