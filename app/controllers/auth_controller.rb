# encoding: UTF-8

class AuthController < ApplicationController
  layout "auth_account"

  def new

  end

  def activate

  end

  def do_activate
    email = format_email(params["email"])
    password = params["temp_password"]

    account = Account.find_by_email_and_temp_password_and_active(email, password, false)
    if account.nil?
      flash[:message] = "Invalid credential, please confirm with system admin."
      redirect_to auth_activate_url
      return
    end

    session[:account] = account
    redirect_to auth_password_url
  end

  def password

  end

  def set_password
    account = session[:account]

    if account.nil?
      flash[:message] = "To activate your account, please login first."
      redirect_to auth_activate_url
      return
    end

    password1 = params["password1"]
    password2 = params["password2"]
    unless password1.eql?(password2)
      flash[:message] = "Passwords are not consist with each other."
      redirect_to auth_password_url
      return
    end

    activate_account(account, password1)
    session[:account] = account
    redirect_to payroll_index_url
  end

  def create
    email = format_email(params["email"])
    password = digest_string(params["password"])

    account = Account.find_by_email_and_password_and_active(email, password, true)

    if account.nil?
      flash[:message] = "Login failed, please try again."
      redirect_to new_auth_url
      return
    end

    session[:account] = account
    redirect_to payroll_index_url
  end

  def logout
    session[:account] = nil
    flash[:message] = "You have logged out."
    redirect_to :action => "new"
  end

  private

  def activate_account(account, password)
    Account.update(account.id, :password => digest_string(password), :active => true)
  end

  def digest_string(message)
    digest = Digest::SHA2.new
    digest.hexdigest(message)
  end

  def format_email(username)
    "#{username}@thoughtworks.com"
  end
end
