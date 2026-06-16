class UserFeedback < ActiveRecord::Base
  attr_accessible :feedbackable_id, :feedbackable_type, :comment, :ip_address, :user_agent, :name, :email

  belongs_to :feedbackable, polymorphic: true
  belongs_to :user

  validates :comment, presence: { message: "ದಯವಿಟ್ಟು ಪ್ರತಿಕ್ರಿಯೆಯನ್ನು ನಮೂದಿಸಿ" }
  validates :feedbackable_id, presence: true
  validates :feedbackable_type, presence: true, inclusion: { in: %w[Vachana Vachanakaara] }

  scope :pending, -> { where(status: 'pending') }
  scope :reviewed, -> { where(status: 'reviewed') }
  scope :dismissed, -> { where(status: 'dismissed') }
  scope :recent_first, -> { order(created_at: :desc) }

  def feedbackable_name
    case feedbackable_type
    when 'Vachana'
      fb = feedbackable
      fb ? "#{fb.vachanakaara.try(:name)} - ವಚನ #{fb.vachanaid}" : 'ವಚನ'
    when 'Vachanakaara'
      fb = feedbackable
      fb ? fb.name : 'ವಚನಕಾರ'
    else
      feedbackable_type
    end
  end
end
