class PayrollController < ApplicationController
  layout "application"

  before_filter :auth_account

  def index
    account = session[:account]
    @payrolls = Account.payrolls account.name_chn, account.name_eng
  end

  def show
    @payroll = Payroll.find_by_id params[:id]

    unless payroll_for_current_account?(@payroll)
      redirect_to payroll_index_url
      return
    end
  end

  private

  def payroll_for_current_account?(payroll)
    account = session[:account]
    payroll.name_chn.eql?(account.name_chn) and payroll.name_eng.eql?(account.name_eng)
  end
end
