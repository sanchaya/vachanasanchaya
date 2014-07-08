class Vachanakaara < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user },
  :params => {
    used_ip: Proc.new{ |controller, model| controller.current_user.current_sign_in_ip }
  }

  default_scope order('name')

  attr_accessible :name, :ankitha_naama,:time_period,:vachana_found,:sex,:information, :parents,:spouse,:birth_place, :reference_book_id
  has_many :vachanas
  belongs_to :reference_book
  has_many :users, through: :user_vachanakaaras
  has_many :user_vachanakaaras, dependent: :destroy


  scope :start_letter, lambda {|letter| where("name like ? ", "#{letter}%" )}
  scope :name_or_ankitha_like, lambda {|name,ankitha| where("name like ? or ankitha_naama like ?", "%#{name}%", "%#{ankitha}%" )}
  scope :name_like, lambda {|name| where("name like ? ", "%#{name}%")}
  scope :ankitha_like, lambda {|ankitha| where("ankitha_naama like ?", "%#{ankitha}%" )}

  scope :not_in_user_vachanakaaras, includes(:user_vachanakaaras).where("id NOT IN (select vachanakaara_id from user_vachanakaaras)")



  def self.to_csv
   CSV.generate do |csv|
    csv << ['Vachanakaara_Name', 'Vachanas Found', 'Vachanas in sanchaya']
    all.each do |vachanakaara|
      csv << [vachanakaara.name, vachanakaara.vachana_found, vachanakaara.vachanas.count]
    end
  end
end

end