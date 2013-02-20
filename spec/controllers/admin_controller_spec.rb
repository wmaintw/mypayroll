# encoding: UTF-8

require 'spec_helper'

describe AdminController do
  describe "GET home" do
    it "render admin home page" do
      get :home
      response.should render_template("home")
    end
  end

  describe "POST upload" do
    it "accept payroll file" do
      params = {:file => fixture_file_upload("/test-payroll.xls")}
      post :upload, params

      flash[:message].should == "Payroll uploaded successfully."

      payroll = Payroll.find_by_name_chn "马伟"
      payroll.should_not == nil
      payroll.salary.should == 1001
    end

    it "should fail gracefully when upload payroll meet problem" do
      Payroll.should_receive(:parse_to_database!).and_return(false)

      params = {:file => fixture_file_upload("/test-payroll.xls")}
      post :upload, params

      flash[:message].should == "Failed to upload payroll."
    end
  end

end
