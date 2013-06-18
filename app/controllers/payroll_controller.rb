class PayrollController < ApplicationController
  layout "application"

  before_filter :auth_account

  def index
    account = session[:account]
    @payrolls = account.my_payrolls
  end

  def show
    @payroll = Payroll.find_by_id params[:id]

    account = session[:account]
    unless @payroll.my_payroll? account.employee_id, account.name_chn
      redirect_to payroll_index_url
      return
    end
  end
end
