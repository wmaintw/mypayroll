# encoding: UTF-8

require 'spec_helper'

describe Account do

  before do
    @account = Account.new
    @account_name = "马伟"
    Payroll.create({:name_chn => @account_name, :salary => 1000, :payroll_for_month => "2013-03-01"})
    Payroll.create({:name_chn => "张三", :salary => 2000, :payroll_for_month => "2013-01-01"})
    Payroll.create({:name_chn => "张三", :salary => 1800, :payroll_for_month => "2013-03-01"})
    Payroll.create({:name_chn => "张三", :salary => 1800, :payroll_for_month => "2013-02-01"})
  end

  it "should get payroll for himself" do
    payrolls = Account.payrolls @account_name
    payrolls.count().should == 1

    payroll = payrolls[0]
    payroll.name_chn.should == @account_name
    payroll.payroll_for_month.to_s.should == "2013-03-01"
  end

  it "should get all payrolls for someone" do
    Payroll.create({:name_chn => @account_name, :salary => 1800, :payroll_for_month => "2013-02-01"})

    payrolls = Account.payrolls @account_name
    payrolls.count().should == 2

    payrolls[0].name_chn.should == @account_name
    payrolls[1].name_chn.should == @account_name
  end

  it "should get all payrolls in correct order" do
    payrolls = Account.payrolls "张三"
    payrolls.count().should == 3

    payrolls[0].payroll_for_month.to_s.should == "2013-03-01"
    payrolls[1].payroll_for_month.to_s.should == "2013-02-01"
    payrolls[2].payroll_for_month.to_s.should == "2013-01-01"
  end

end
