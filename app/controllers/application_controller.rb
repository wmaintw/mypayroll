class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def auth_admin
    unless session[:admin] == "true"
      session[:admin] = nil
      redirect_to new_admin_auth_url
    end
  end

end
