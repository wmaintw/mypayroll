class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def auth_admin
    if session[:admin] == nil
      redirect_to new_admin_auth_url
    end
  end

  def auth_account
    if session[:account] == nil
      redirect_to new_auth_url
    end
  end

end
