require 'spec_helper'

describe Admin::AuthController do
  before do
    @correct_credential = {:username => "admin", :password => "password", :password_crypt => "5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8"}
    @incorrect_credential = {:username => "admin", :password => "incorrect", :password_crypt => "203d3536bd62ad33ac70b7ea3d4f5e10b6d52ebd0cb7582841a053aebb7186a3"}
  end

  it "should open login page" do
    get :new
    response.should render_template "auth/new"
  end

  it "should login successfully with correct credential" do
    Admin.should_receive(:find_by_username_and_password)
      .with(@correct_credential[:username], @correct_credential[:password_crypt])
      .and_return(true)

    post :create, @correct_credential
    response.should redirect_to new_admin_payroll_path
    session[:admin].should == "true"
  end

  it "should failed when incorrect credential provided" do
    Admin.should_receive(:find_by_username_and_password)
      .with(@incorrect_credential[:username], @incorrect_credential[:password_crypt])
      .and_return(false)

    post :create, @incorrect_credential
    response.should redirect_to "/admin/login"
    flash[:message].should == "Login failed, please try again."
    session[:admin].should == nil
  end

  it "should logout successfully" do
    get :logout
    flash[:message].should == "You have logged out."
    session[:admin].should == nil
  end
end
