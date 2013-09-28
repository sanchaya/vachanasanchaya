class Vachanakaara < ActiveRecord::Base
  attr_accessible :name
  has_many :vachanas
end
