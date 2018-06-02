class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protected
  def authenticate_inviter!
    unless current_user.admin? or current_user.manager?
      redirect_to root_url, :alert => "Access Denied"
    end
    super
  end
  def authenticate_admin!
    unless current_user.admin?
      redirect_to root_url, :alert => "Access Denied"
    end
  end
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update , keys: [:display_name])
  end
end
