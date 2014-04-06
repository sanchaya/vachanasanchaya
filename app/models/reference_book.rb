class ReferenceBook < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user },
  :params => {
    used_ip: Proc.new{ |controller, model| controller.current_user.current_sign_in_ip }
  }
  
 attr_accessible :book_name, :book_volume, :publisher, :author, :published_year, :isbn, :language, :reference_type
 has_many :vachanakaaras

 validates :book_name, :book_volume, presence: true

end
