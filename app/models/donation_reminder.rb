class DonationReminder < ActiveRecord::Base
  attr_accessible :email, :phone, :source

  validates :email, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }

  scope :recent, -> { order(created_at: :desc) }
end
