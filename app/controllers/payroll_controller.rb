class PayrollController < ApplicationController
  layout "application"

  def index
    account = session[:account]
    @payrolls = Account.payrolls account.name_chn, account.name_eng
  end

end
