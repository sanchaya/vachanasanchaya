class UserFeedbacksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_spam, only: [:create]

  def create
    @feedback = UserFeedback.new(params[:user_feedback])
    @feedback.user = current_user
    @feedback.ip_address = request.remote_ip
    @feedback.user_agent = request.user_agent

    if UserFeedback.rate_limited?(current_user)
      respond_to do |format|
        format.html { redirect_to :back, alert: 'ನೀವು ಒಂದು ಗಂಟೆಯಲ್ಲಿ ಹೆಚ್ಚು ಪ್ರತಿಕ್ರಿಯೆಗಳನ್ನು ಸಲ್ಲಿಸಿದ್ದೀರಿ. ದಯವಿಟ್ಟು ಸ್ವಲ್ಪ ಸಮಯದ ನಂತರ ಪ್ರಯತ್ನಿಸಿ.' }
        format.json { render json: { error: 'Rate limit exceeded' }, status: 429 }
      end
      return
    end

    if @feedback.save
      respond_to do |format|
        format.html { redirect_to :back, notice: 'ನಿಮ್ಮ ಪ್ರತಿಕ್ರಿಯೆಗೆ ಧನ್ಯವಾದಗಳು. ನಿಮ್ಮ ಅಭಿಪ್ರಾಯವನ್ನು ನಾವು ಪರಿಶೀಲಿಸುತ್ತೇವೆ.' }
        format.json { render json: { success: true, message: 'ಪ್ರತಿಕ್ರಿಯೆಗೆ ಧನ್ಯವಾದಗಳು' } }
      end
    else
      respond_to do |format|
        format.html { redirect_to :back, alert: @feedback.errors.full_messages.join(', ') }
        format.json { render json: { error: @feedback.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private

  def check_spam
    if params[:gotcha].present?
      respond_to do |format|
        format.html { redirect_to :back, alert: 'Spam detected.' }
        format.json { render json: { error: 'Spam' }, status: 422 }
      end
    end
  end
end
