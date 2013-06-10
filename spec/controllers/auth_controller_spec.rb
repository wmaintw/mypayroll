require 'spec_helper'

describe AuthController do

  before do
    session[:account] = nil
  end


  it "should open activate login page" do
    get :activate
    response.should render_template "auth/activate"
  end

  it "should login successfully with correct credential" do
    account = Account.new
    params = {:email => "123@thoughtworks.com", :temp_password => "abc"}

    Account.should_receive(:find_by_email_and_temp_password_and_active)
    .with(params[:email], params[:temp_password], false)
    .and_return(account)

    post :do_activate, params

    session[:account].should_not == nil
    response.should redirect_to password_url
  end

  it "should not login with incorrect credential" do
    params = {:email => "incorrect email", :temp_password => "incorrect password"}

    Account.should_receive(:find_by_email_and_temp_password_and_active)
    .with(params[:email], params[:temp_password], false)
    .and_return(nil)

    post :do_activate, params

    session[:account].should == nil
    response.should redirect_to activate_url
  end

  it "should open set password page" do
    get :password
    response.should render_template "auth/password"
  end

  it "should redirect to activate page given user not login" do
    params = {:password1 => "abc", :password2 => "abc"}
    session[:account] = nil

    post :set_password, params

    session[:account].should == nil
    response.should redirect_to activate_url
  end

  it "should redirect to activate page given passwords are not consist with each other" do
    params = {:password1 => "abc", :password2 => "def"}
    session[:account] = Account.new

    post :set_password, params

    session[:account].should_not == nil
    response.should redirect_to password_url
  end

  it "should activate account successfully" do
    params = {:password1 => "abc", :password2 => "abc"}
    session[:account] = Account.new
    Account.should_receive(:update)

    post :set_password, params

    session[:account].should_not == nil
    response.should redirect_to payroll_index_url
  end

  it "should logout successfully" do
    get :logout
    flash[:message].should == "You have logged out."
    session[:account].should == nil
  end
end
