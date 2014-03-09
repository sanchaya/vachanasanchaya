class UserVachanakaara < ActiveRecord::Base
  attr_accessible :user_id, :vachanakaara_id
  belongs_to :user
  belongs_to :vachanakaara

  # validates_uniqueness_of :user_id, :scope => :vachanakaara_id
  validates_uniqueness_of :vachanakaara_id
end
