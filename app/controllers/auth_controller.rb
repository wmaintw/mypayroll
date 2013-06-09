# encoding: UTF-8

class AuthController < ApplicationController
  layout "auth_account"

  def new

  end

  def create
    #digest = Digest::SHA2.new
    #digest.update(params["password"])
    #password = digest.hexdigest

    session[:account] = Account.new(:name_chn => "马伟", :name_eng => "Ma,Wei")
    redirect_to payroll_index_url
  end

  def logout
    session[:account] = nil
    flash[:message] = "You have logged out."
    redirect_to :action => "new"
  end
end
