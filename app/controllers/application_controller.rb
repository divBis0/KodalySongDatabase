class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  protected
  def authenticate_inviter!
    unless current_user.admin?
      redirect_to root_url, :alert => "Access Denied"
    end
    super
  end
  def authenticate_admin!
    unless current_user.admin?
      redirect_to root_url, :alert => "Access Denied"
    end
  end
end
