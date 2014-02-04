class Vachanakaara < ActiveRecord::Base
  default_scope order('name')
  attr_accessible :name, :ankitha_naama
  has_many :vachanas


  scope :start_letter, lambda {|letter| where("name like ? ", "#{letter}%" )}
  scope :name_or_ankitha_like, lambda {|name,ankitha| where("name like ? or ankitha_naama like ?", "%#{name}%", "%#{ankitha}%" )}

end
