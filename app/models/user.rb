class User < ActiveRecord::Base

  before_create :default_user_role


  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,:registerable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
  :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role_id
  # attr_accessible :title, :body

  belongs_to :role
  has_many :vachanakaaras, through: :user_vachanakaaras
  has_many :user_vachanakaaras


  def is_admin?
    user_role == "Admin"
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
