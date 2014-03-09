class ApplicationController < ActionController::Base
  protect_from_forgery
  # before_filter :set_local_language

  def set_local_language
    I18n.locale = 'kn'
  end

  def authenticate_user_role!
    if current_user && current_user.is_admin?
      true
    else
      flash[:error] = "Sorry you dont have permission"
      redirect_to current_user ? root_path : new_user_session_path
    end
  end

 
end
