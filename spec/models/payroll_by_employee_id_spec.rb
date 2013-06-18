# encoding: UTF-8

require 'spec_helper'

describe Account do
  before do
    Payroll.delete_all
  end

  it "should get payrolls for current account by employee id" do
    account = Account.new(:employee_id => 1, :name_chn => "张三", :name_eng => "Zhang,San")
    @payrolls = [Payroll.new(:employee_id => 1), Payroll.new(:employee_id => 1)]

    Payroll.should_receive(:find_all_by_employee_id_and_name_chn).with(account.employee_id, account.name_chn, {:order => "payroll_for_month desc"}).and_return(@payrolls)

    my_payrolls = account.my_payrolls
    my_payrolls.should match_array @payrolls
  end

  it "should not get other's payroll" do
    account = Account.new(:employee_id => 1, :name_chn => "张三", :name_eng => "Zhang,San")

    Payroll.should_receive(:find_all_by_employee_id_and_name_chn).with(account.employee_id, account.name_chn, {:order => "payroll_for_month desc"}).and_return(nil)

    my_payrolls = account.my_payrolls
    my_payrolls.should be_nil
  end

  it "should get all payrolls in correct order" do
    account = Account.new(:employee_id => 1, :name_chn => "张三", :name_eng => "Zhang,San")
    Payroll.create({:name_chn => "张三", :employee_id => 1, :salary => 2000, :payroll_for_month => "2013-01-01"})
    Payroll.create({:name_chn => "张三", :employee_id => 1, :salary => 1800, :payroll_for_month => "2013-03-01"})
    Payroll.create({:name_chn => "张三", :employee_id => 1, :salary => 1800, :payroll_for_month => "2013-02-01"})

    my_payrolls = account.my_payrolls

    my_payrolls[0].payroll_for_month.to_s.should == "2013-03-01"
    my_payrolls[1].payroll_for_month.to_s.should == "2013-02-01"
    my_payrolls[2].payroll_for_month.to_s.should == "2013-01-01"
  end

  it "should not get any payrolls given employee id of current account is incorrect" do
    account = Account.new(:employee_id => nil)
    Payroll.create({:name_chn => "张三", :employee_id => 5, :salary => 2000, :payroll_for_month => "2013-01-01"})

    my_payrolls = account.my_payrolls

    my_payrolls.count.should == 0
  end

  it "should not get any payrolls given name miss match for current account" do
    account = Account.new(:name_chn => "李四", :employee_id => 5)
    Payroll.create({:name_chn => "张三", :employee_id => 5, :salary => 2000, :payroll_for_month => "2013-01-01"})

    my_payrolls = account.my_payrolls

    my_payrolls.count.should == 0
  end
end