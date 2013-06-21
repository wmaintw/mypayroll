require 'spec_helper'
include Digest

describe Admin do
  it "should set new password successfully when old password is correct" do
    admin = Admin.new(:password => digest_string("password"))
    old_password = "password"
    new_password1 = "new password"
    new_password2 = new_password1
    encrypted_new_password = digest_string(new_password1)

    admin.should_receive(:update_column).with(:password, encrypted_new_password).and_return(true)

    result = admin.change_password(old_password, new_password1, new_password2)

    result.should be_true
    admin.password.should eq(encrypted_new_password)
    end

  it "should not change password when old password is not correct" do
    admin = Admin.new(:password => digest_string("password"))
    old_password = "incorrect old password"
    new_password1 = "new"
    new_password2 = new_password1

    result = admin.change_password(old_password, new_password1, new_password2)

    result.should be_false
  end

  it "should not change password when old password is correct but new passwords not consist" do
    admin = Admin.new(:password => digest_string("password"))
    old_password = "password"
    new_password1 = "new password1"
    new_password2 = "new password2 that not same with new password1"

    result = admin.change_password(old_password, new_password1, new_password2)

    result.should be_false
  end

  it "should not change password when new password is not provided" do
    admin = Admin.new(:password => digest_string("password"))
    old_password = "password"
    new_password1 = ""
    new_password2 = ""
    admin.should_not_receive(:update_column)

    result = admin.change_password(old_password, new_password1, new_password2)

    result.should be_false
  end

  it "should not change password when strength of new password is not enough" do
    admin = Admin.new(:password => digest_string("password"))
    old_password = "password"
    new_password1 = "1234567"
    new_password2 = "1234567"
    admin.should_not_receive(:update_column)

    result = admin.change_password(old_password, new_password1, new_password2)

    result.should be_false
  end
end
