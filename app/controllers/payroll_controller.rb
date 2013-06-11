class PayrollController < ApplicationController
  layout "application"

  before_filter :auth_account

  def index
    account = session[:account]
    @payrolls = Account.payrolls account.name_chn, account.name_eng
  end

end
