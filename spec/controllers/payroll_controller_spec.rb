# encoding: UTF-8

require 'spec_helper'

def create_payroll(employee_id, account_name_chn, payroll_for_month = "2013-01-01", salary = 1000)
  Payroll.create({:employee_id => employee_id, :name_chn => account_name_chn, :payroll_for_month => payroll_for_month, :salary => salary})
end

describe PayrollController do

  before do
    session[:account] = Account.new

    @current_account = Account.new
    @current_account.name_chn = "张三"
    @current_account.name_eng = "Zhang,San"
    @current_account.employee_id = 1

    @non_current_account = Account.new
    @non_current_account.name_chn = "李四"
    @non_current_account.name_eng = "Li,Si"
    @non_current_account.employee_id = 2

    Payroll.delete_all
  end

  it "should redirect to login page given user not logged in" do
    session[:account] = nil

    get :index
    response.should redirect_to new_auth_url
  end

  it "should open payroll list page" do
    get :index
    response.should render_template "payroll/index"
  end

  it "should list all payrolls for current account" do
    session[:account] = @current_account
    payroll_first = create_payroll(@current_account.employee_id, @current_account.name_chn, "2013-01-01")
    payroll_second = create_payroll(@current_account.employee_id, @current_account.name_chn, "2013-02-01")
    payroll_not_for_current_account = create_payroll(@non_current_account.employee_id, @non_current_account.name_chn, "2013-01-01")

    get :index

    expect(assigns[:payrolls]).to match_array([payroll_first, payroll_second])
  end

  it "should list payrolls that both employee id and chinese name are matched" do
    session[:account] = @current_account
    matched_payroll = create_payroll(@current_account.employee_id, @current_account.name_chn, "2013-01-01")
    name_not_matched_payroll = create_payroll(@current_account.employee_id, "错误的中文名", "2013-01-01")
    employee_id_not_matched_payroll = create_payroll(9928, @current_account.name_chn, "2013-01-01")
    employee_id_and_name_not_matched_payroll = create_payroll(9928, "错误的中文名", "2013-01-01")

    get :index

    expect(assigns[:payrolls]).to match_array([matched_payroll])
  end

  it "should open payroll detail page for current account" do
    session[:account] = @current_account
    payroll = create_payroll(@current_account.employee_id, @current_account.name_chn, "2013-01-01")
    params = {:id => payroll.id}

    get :show, params

    expect(assigns[:payroll]).to eq(payroll)
    end

  it "should not open payroll detail page that is not for current account" do
    session[:account] = @current_account
    payroll = create_payroll(@non_current_account.employee_id, @non_current_account.name_chn, "2013-01-01")
    params = {:id => payroll.id}

    get :show, params

    response.should redirect_to(payroll_index_url)
  end

end
