class UserFeedbacksController < ApplicationController
  before_filter :check_spam, only: [:create]

  def create
    @feedback = UserFeedback.new(params[:user_feedback])
    @feedback.user = current_user if user_signed_in?
    @feedback.ip_address = request.remote_ip
    @feedback.user_agent = request.user_agent

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
      return
    end
  end
end