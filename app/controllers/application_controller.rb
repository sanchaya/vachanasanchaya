class ApplicationController < ActionController::Base
 include PublicActivity::StoreController
 protect_from_forgery
 before_filter :set_local_language

 rescue_from CanCan::AccessDenied do |exception|
  redirect_to root_url, :alert => exception.message
end

def set_local_language
  I18n.locale =  params[:locale]  || 'kn'
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


def after_sign_in_path_for(resource)
  if resource.is_reviewer?
    user_review_vachanas_path(current_user)
  elsif resource.is_publisher?
    user_publishers_path(current_user)  
  elsif resource.is_admin?
    admin_panel_path
  else
    super
  end


end

end
