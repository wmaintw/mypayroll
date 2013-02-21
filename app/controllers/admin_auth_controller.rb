class AdminAuthController < ApplicationController
  layout "auth_admin"

  def new

  end

  def create
    digest = Digest::SHA2.new
    digest.update(params["password"])
    password = digest.hexdigest

    admin = Admin.find_by_username_and_password params[:username], password
    if admin
      redirect_to "/admin/home"
    else
      flash[:message] = "Login failed, please try again."
      redirect_to "/admin/login"
    end
  end
end
