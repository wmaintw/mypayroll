# encoding: UTF-8

require 'spec_helper'

describe Account do

  before do
    @account = Account.new
    @account_name_chn = "马伟"
    @account_name_eng = "Ma,Wei"
    Payroll.create({:name_chn => @account_name_chn, :name_eng => @account_name_eng, :salary => 1000, :payroll_for_month => "2013-03-01"})
    Payroll.create({:name_chn => "张三", :name_eng => "San,Zhang", :salary => 2000, :payroll_for_month => "2013-01-01"})
    Payroll.create({:name_chn => "张三", :name_eng => "San,Zhang", :salary => 1800, :payroll_for_month => "2013-03-01"})
    Payroll.create({:name_chn => "张三", :name_eng => "San,Zhang", :salary => 1800, :payroll_for_month => "2013-02-01"})
  end

  it "should get payroll for himself" do
    payrolls = Account.payrolls @account_name_chn, @account_name_eng
    payrolls.count().should == 1

    payroll = payrolls[0]
    payroll.name_chn.should == @account_name_chn
    payroll.payroll_for_month.to_s.should == "2013-03-01"
  end

  it "should get all payrolls for someone" do
    Payroll.create({:name_chn => @account_name_chn, :name_eng => @account_name_eng, :salary => 1800, :payroll_for_month => "2013-02-01"})

    payrolls = Account.payrolls @account_name_chn, @account_name_eng
    payrolls.count().should == 2

    payrolls[0].name_chn.should == @account_name_chn
    payrolls[1].name_chn.should == @account_name_chn
  end

  it "should get all payrolls in correct order" do
    payrolls = Account.payrolls "张三", "San,Zhang"
    payrolls.count().should == 3

    payrolls[0].payroll_for_month.to_s.should == "2013-03-01"
    payrolls[1].payroll_for_month.to_s.should == "2013-02-01"
    payrolls[2].payroll_for_month.to_s.should == "2013-01-01"
  end

  it "should not get any payroll if name is incorrect" do
    payrolls = Account.payrolls "张三", "Wrong,Person,Name"
    payrolls.count().should == 0
  end

end
