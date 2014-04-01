class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_local_language

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def set_local_language
    I18n.locale = 'kn'
  end

  def authenticate_user_role!
    if current_user && (current_user.is_admin? or current_user.role.name == "Admin")
      true
    else
      flash[:error] = "Sorry you dont have permission"
      redirect_to current_user ? root_path : new_user_session_path
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, params)
  end


end
