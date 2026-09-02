class Donation < ActiveRecord::Base
  attr_accessible :donor_name, :donor_email, :amount, :currency, :payment_id, :razorpay_order_id, :status, :notes, :paid_at

  scope :recent, -> { order(created_at: :desc) }

  validates :amount, numericality: { greater_than: 0 }
  validates :donor_email, format: { with: /\A[^@\s]+@[^@\s]+\z/, allow_blank: true }
  validates :currency, inclusion: { in: %w[INR USD EUR GBP] }
  validates :status, inclusion: { in: %w[pending completed failed refunded] }
end
