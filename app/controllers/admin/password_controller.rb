class Admin::PasswordController < ApplicationController
  layout "application_admin"

  def edit

  end

  def update
    admin = session[:admin]
    result = admin.change_password(params[:old_password], params[:new_password1], params[:new_password2])

    if result == true
      session[:admin] = admin
      flash[:message] = "Password changed successfully."
    else
      flash[:message] = "Failed to change password, possible reason:
                        (1) old password is incorrect,
                        (2) new passwords are not consist,
                        (3) password must equal or longer than 8 chars."
    end

    redirect_to admin_password_url
  end
end


