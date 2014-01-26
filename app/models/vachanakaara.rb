class Vachanakaara < ActiveRecord::Base
  attr_accessible :name, :ankitha_naama
  has_many :vachanas


  scope :start_letter, lambda {|letter| where("name like ? ", "#{letter}%" )}
  scope :name_like, lambda {|name| where("name like ? ", "%#{name}%" )}

end
