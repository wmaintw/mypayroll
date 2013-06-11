require 'spec_helper'

describe PayrollController do

  before do
    session[:account] = Account.new
  end

  it "should open payroll list page" do
    get :index
    response.should render_template "payroll/index"
  end

  it "should redirect to login page given user not logged in" do
    session[:account] = nil

    get :index
    response.should redirect_to new_auth_url
  end

end
