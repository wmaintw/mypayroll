require 'spec_helper'

describe AdminAuthController do
  before do
    @correct_credential = {:username => "admin", :password => "password"}
    @incorrect_credential = {:username => "admin", :password => "incorrect"}
  end

  it "should open login page" do
    get :new
    response.should render_template "admin_auth/new"
  end

  it "should login successfully with correct credential" do
    Admin.should_receive(:find_by_username_and_password)
      .with(@correct_credential[:username], @correct_credential[:password])
      .and_return(true)

    post :create, @correct_credential
    response.should redirect_to "/admin/home"
  end

  it "should failed when incorrect credential provided" do
    Admin.should_receive(:find_by_username_and_password)
      .with(@incorrect_credential[:username], @incorrect_credential[:password])
      .and_return(false)

    post :create, @incorrect_credential
    response.should redirect_to "/admin/login"
  end
end
