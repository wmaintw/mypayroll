# encoding: UTF-8

require 'spec_helper'

describe AdminController do
  describe "GET home" do
    it "render admin home page" do
      get :home
      response.should render_template("home")
    end
  end

  describe "POST update" do
    it "accept payroll file" do
      params = {:file => fixture_file_upload("/test-payroll.xls")}
      post :upload, params

      payroll = Payroll.find_by_name_chn "马伟"
      payroll.should_not == nil
      payroll.salary.should == 1001
    end
  end
end
