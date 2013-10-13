class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_local_language

  def set_local_language
    I18n.locale = 'kn'
  end

end
