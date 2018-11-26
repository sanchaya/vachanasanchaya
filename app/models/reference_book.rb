class ReferenceBook < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user },
  :params => {
    used_ip: Proc.new{ |controller, model| controller.current_user.current_sign_in_ip }
  }
  
  attr_accessible :book_name, :book_volume, :publisher, :author, :published_year, :isbn, :language, :reference_type
  has_many :vachanakaaras

  validates :book_name, :book_volume, presence: true


  def self.to_csv
    CSV.generate do |csv|
      csv << ['Book Name', 'Book Volume', 'Reference Id']
      all.each do |reference|
        csv << [reference.book_name, reference.book_volume, reference.id]
      end
    end
  end

  def self.vachanakaara_to_csv
    CSV.generate do |csv|
      csv << ['Book Name', 'Book Volume', 'vachanakaaras']
      all.each do |reference|
        csv << [reference.book_name, reference.book_volume, reference.vachanakaaras.pluck('name').join(',')
        ]
      end
    end
  end

end
