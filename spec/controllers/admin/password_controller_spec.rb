require 'spec_helper'
include Digest

describe Admin::PasswordController do
  before do
    @old_password = "password"
    @admin = Admin.new
    @admin.password = digest_string(@old_password)
    session[:admin] = @admin
  end

  it "should open change password page" do
    get :edit
    response.should render_template("admin/password/edit")
  end

  it "should change password successfully when old and new passwords are correct" do
    new_password = "new password"
    params = {:old_password => @old_password, :new_password1 => new_password, :new_password2 => new_password}

    @admin.should_receive(:update_column).with(:password, digest_string(new_password)).and_return(true)

    post :update, params

    flash[:message].should include("success")
    response.should redirect_to(admin_password_url)
    @admin.password.should eq(digest_string(new_password))
  end

  it "should not change password when old passwords is incorrect" do
    new_password = "new"
    params = {:old_password => "incorrect old password", :new_password1 => new_password, :new_password2 => new_password}

    post :update, params

    flash[:message].should include("Failed")
    response.should redirect_to(admin_password_url)
    @admin.password.should eq(digest_string(@old_password))
  end

  it "should not change password when new passwords is provided" do
    new_password = ""
    params = {:old_password => @old_password, :new_password1 => new_password, :new_password2 => new_password}

    post :update, params

    flash[:message].should include("Failed")
    response.should redirect_to(admin_password_url)
    @admin.password.should eq(digest_string(@old_password))
  end

  it "should not change password when strength of new passwords is not enough" do
    new_password = "1234567"
    params = {:old_password => @old_password, :new_password1 => new_password, :new_password2 => new_password}

    post :update, params

    flash[:message].should include("Failed")
    response.should redirect_to(admin_password_url)
    @admin.password.should eq(digest_string(@old_password))
  end
end
