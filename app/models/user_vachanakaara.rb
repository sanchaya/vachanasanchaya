class UserVachanakaara < ActiveRecord::Base
  attr_accessible :user_id, :vachanakaara_id
  belongs_to :user
  belongs_to :vachanakaara
end
