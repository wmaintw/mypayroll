class PasswordController < ApplicationController
  layout "application"

  def edit

  end

  def update
    account = session[:account]
    result = account.change_password(params[:old_password], params[:new_password1], params[:new_password2])

    if result == true
      session[:account] = account
      flash[:message] = "Password changed successfully."
    else
      flash[:message] = "Failed to change password, possible reason:
                        (1) old password is incorrect,
                        (2) new passwords are not consist,
                        (3) password must equal or longer than 8 chars."
    end

    redirect_to password_url
  end
end


