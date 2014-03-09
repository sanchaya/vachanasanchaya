class Vachanakaara < ActiveRecord::Base
  default_scope order('name')

  attr_accessible :name, :ankitha_naama,:time_period,:vachana_found,:sex,:information, :parents,:spouse,:birth_place, :reference_book_id
  has_many :vachanas
  belongs_to :reference_book
  has_many :users, through: :user_vachanakaaras
  has_many :user_vachanakaaras


  scope :start_letter, lambda {|letter| where("name like ? ", "#{letter}%" )}
  scope :name_or_ankitha_like, lambda {|name,ankitha| where("name like ? or ankitha_naama like ?", "%#{name}%", "%#{ankitha}%" )}
  scope :name_like, lambda {|name| where("name like ? ", "%#{name}%")}
  scope :ankitha_like, lambda {|ankitha| where("ankitha_naama like ?", "%#{ankitha}%" )}
end
