require 'spec_helper'

describe AuthController do

  before do
    session[:account] = nil
  end

  it "should open login page" do
    get :new
    response.should render_template "auth/new"
  end

  it "should login successfully" do
    params = {:email => "123", :password => "abc"}
    Account.should_receive(:find_by_email_and_password_and_active)
      .with("#{params[:email]}@thoughtworks.com", digest_string(params[:password]), true)
      .and_return(Account.new)

    post :create, params

    response.should redirect_to payroll_index_url
  end

  it "should not login given incorrect credential" do
    params = {:email => "incorrect email", :password => "incorrect password"}
    Account.should_receive(:find_by_email_and_password_and_active)
      .with("#{params[:email]}@thoughtworks.com", digest_string(params[:password]), true)
      .and_return(nil)

    post :create, params

    response.should redirect_to new_auth_url
  end

  it "should open activate login page" do
    get :activate
    response.should render_template "auth/activate"
  end

  it "should login successfully to activate account with correct credential" do
    account = Account.new
    params = {:email => "123", :temp_password => "abc"}

    Account.should_receive(:find_by_email_and_temp_password_and_active)
      .with("#{params[:email]}@thoughtworks.com", params[:temp_password], false)
      .and_return(account)

    post :do_activate, params

    session[:account].should_not == nil
    response.should redirect_to auth_password_url
  end

  it "should not login to activate account with incorrect credential" do
    params = {:email => "incorrect email", :temp_password => "incorrect password"}

    Account.should_receive(:find_by_email_and_temp_password_and_active)
    .with("#{params[:email]}@thoughtworks.com", params[:temp_password], false)
    .and_return(nil)

    post :do_activate, params

    session[:account].should == nil
    response.should redirect_to auth_activate_url
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
    response.should redirect_to auth_activate_url
  end

  it "should redirect to activate page given passwords are not consist with each other" do
    params = {:password1 => "abc", :password2 => "def"}
    session[:account] = Account.new

    post :set_password, params

    session[:account].should_not == nil
    response.should redirect_to auth_password_url
  end

  it "should redirect to activate page given passwords are not entered" do
    account = Account.new
    account.id = 1231
    session[:account] = account
    params = {:password1 => "", :password2 => ""}
    Account.should_not_receive(:update)

    post :set_password, params

    session[:account].should_not == nil
    response.should redirect_to auth_password_url
  end

  it "should redirect to activate page given length of password is not enough" do
    account = Account.new
    account.id = 1231
    session[:account] = account
    params = {:password1 => "1234567", :password2 => "1234567"}
    Account.should_not_receive(:update)

    post :set_password, params

    session[:account].should_not == nil
    response.should redirect_to auth_password_url
  end

  it "should activate account successfully" do
    params = {:password1 => "abcd1234", :password2 => "abcd1234"}
    id = 1
    account = Account.new
    account.id = id
    session[:account] = account
    Account.should_receive(:update).with(id, :password => digest_string(params[:password1]), :active => true)

    post :set_password, params

    session[:account].should_not == nil
    response.should redirect_to payroll_index_url
  end

  it "should logout successfully" do
    get :logout
    flash[:message].should == "You have logged out."
    session[:account].should == nil
  end

  def digest_string(message)
    digest = Digest::SHA2.new
    digest.hexdigest(message)
  end
end
