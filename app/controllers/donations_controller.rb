class DonationsController < ApplicationController
  protect_from_forgery except: :webhook

  def create
    @donation = Donation.new(params[:donation])
    @donation.status = 'completed'
    @donation.paid_at = Time.current

    if @donation.save
      render json: { success: true, donation: @donation.as_json(only: [:id, :donor_name, :amount, :currency, :status]) }
    else
      render json: { success: false, errors: @donation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def webhook
    payload = request.body.read
    sig_header = request.env['HTTP_X_RAZORPAY_SIGNATURE']

    begin
      event = JSON.parse(payload)
      event_type = event['event']

      if event_type == 'payment.captured'
        payment = event['payload']['payment']['entity']
        donation = Donation.find_by(payment_id: payment['id'])
        if donation
          donation.update(status: 'completed', paid_at: Time.current)
        end
      end

      render json: { status: 'ok' }
    rescue => e
      Rails.logger.error "Webhook error: #{e.message}"
      render json: { status: 'error' }, status: :bad_request
    end
  end
end
