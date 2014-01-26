class Vachanakaara < ActiveRecord::Base
  attr_accessible :name, :ankitha_naama
  has_many :vachanas


  scope :start_letter, lambda {|letter| where("name like ? ", "#{letter}%" )}


end
