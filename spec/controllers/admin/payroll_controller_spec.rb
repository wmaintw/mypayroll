# encoding: UTF-8

require 'spec_helper'

describe Admin::PayrollController do
  describe "Authentication" do
    it "should redirect to login page if not logged in" do
      get :new
      response.should redirect_to new_admin_auth_url
    end
  end

  describe "visit payroll upload page" do
    before do
      session[:admin] = "true"
    end

    it "render payroll home page" do
      get :new
      response.should render_template("payroll/new")
    end
  end

  describe "upload payroll" do
    before do
      session[:admin] = "true"
    end

    it "accept payroll file" do
      params = {:file => fixture_file_upload("/test-payroll.xls"), :date => {:year => 2013, :month => 2}}
      post :create, params

      flash[:message].should == "Payroll uploaded successfully."

      payroll = Payroll.find_by_name_chn "马伟"
      payroll.should_not == nil

      payroll.salary.should == 7142.86
      payroll.total_allowance.should == 1000
      payroll.payroll_for_month.should == Date.new(2013, 02, 01)
    end

    it "should fail gracefully when upload payroll meet problem" do
      Payroll.should_receive(:parse_to_database!).and_return(false)

      params = {:file => fixture_file_upload("/test-payroll.xls"), :date => {:year => 2013, :month => 2}}
      post :create, params

      flash[:message].should == "Failed to upload payroll."
    end
  end

end
