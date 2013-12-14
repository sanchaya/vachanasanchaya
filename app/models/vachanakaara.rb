class Vachanakaara < ActiveRecord::Base
  attr_accessible :name
  has_many :vachanas


scope :start_letter, lambda {|letter| where("name like ? ", "#{letter}%" )}

end
