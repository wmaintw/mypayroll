# encoding: UTF-8

require 'spec_helper'

describe Account do
  it "should change password when old and new password are correct" do
    old_password = "password"
    new_password = "new password"
    encrypted_new_password = digest_string(new_password)
    account = Account.new(:password => digest_string(old_password))

    account.should_receive(:update_column).with(:password, encrypted_new_password).and_return(true)

    result = account.change_password(old_password, new_password, new_password)

    result.should be_true
    account.password.should eq(encrypted_new_password)
  end

  it "should not change password when old password is incorrect" do
    old_password = "password"
    new_password = "new password"
    encrypted_old_password = digest_string(old_password)
    account = Account.new(:password => encrypted_old_password)

    result = account.change_password("incorrect old password", new_password, new_password)

    result.should be_false
    account.password.should eq(encrypted_old_password)
  end

  it "should not change password when old password is correct but new passwords not consist" do
    old_password = "password"
    new_password = "new password"
    encrypted_old_password = digest_string(old_password)
    account = Account.new(:password => encrypted_old_password)

    result = account.change_password(old_password, new_password, "not consisted new password")

    result.should be_false
    account.password.should eq(encrypted_old_password)
  end

  it "should not change password when new password is not provided" do
    old_password = "abcd1234"
    new_password = ""
    encrypted_old_password = digest_string(old_password)
    account = Account.new(:password => encrypted_old_password)
    account.should_not_receive(:update_column)

    result = account.change_password(old_password, new_password, new_password)

    result.should be_false
    account.password.should eq(encrypted_old_password)
  end

  it "should not change password when strength of new password is not enough" do
    old_password = "abcd1234"
    new_password = "1234567"
    encrypted_old_password = digest_string(old_password)
    account = Account.new(:password => encrypted_old_password)
    account.should_not_receive(:update_column)

    result = account.change_password(old_password, new_password, new_password)

    result.should be_false
    account.password.should eq(encrypted_old_password)
  end
end