class Admin::AuthController < ApplicationController
  layout "auth_admin"

  def new

  end

  def create
    digest = Digest::SHA2.new
    digest.update(params["password"])
    password = digest.hexdigest

    admin = Admin.find_by_username_and_password params[:username], password
    if admin
      session[:admin] = "true"
      redirect_to new_admin_payroll_url
    else
      flash[:message] = "Login failed, please try again."
      redirect_to "/admin/login"
    end
  end

  def logout
    session[:admin] = nil
    flash[:message] = "You have logged out."
    redirect_to :action => "new"
  end
end
