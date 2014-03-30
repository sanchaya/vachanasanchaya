class User < ActiveRecord::Base

  before_create :default_user_role


  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,:registerable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
  :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role_id, :name
  # attr_accessible :title, :body

  belongs_to :role
  has_many :vachanakaaras, through: :user_vachanakaaras
  has_many :user_vachanakaaras, dependent: :destroy

  validates :name,:role_id, presence: true


  scope :not_is_admin,lambda {|user| where("user_role != 'Admin' and id != ?", user.id) }

  def is_admin?
    self.role.name == "Admin"
  end

  def is_reviewer?
    self.role.name == "Reviewer"
  end


  def is_publisher?
    self.role.name == "Publisher"
  end
  


  def self.assign_vachanakaara(user, vachanakaaras)
    vachanakaaras.each do |v_id|
      user.user_vachanakaaras.create(vachanakaara_id: v_id)
    end
  end

  private

  def default_user_role
    self.user_role = "Student"
  end


end
