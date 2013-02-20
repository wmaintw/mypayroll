class AdminAuthController < ApplicationController
  layout "auth_admin"

  def new

  end

  def create
    admin = Admin.find_by_username_and_password params[:username], params[:password]
    if admin
      redirect_to "/admin/home"
    else
      redirect_to "/admin/login"
    end
  end
end
