# encoding: UTF-8

require 'spec_helper'

describe Account do
  it "should get payrolls for current account by employee id" do
    account = Account.new(:employee_id => 1, :name_chn => "张三", :name_eng => "Zhang,San")
    @payrolls = [Payroll.new(:employee_id => 1), Payroll.new(:employee_id => 1)]

    Payroll.should_receive(:find_all_by_employee_id).with(account.employee_id).and_return(@payrolls)

    my_payrolls = account.my_payrolls
    my_payrolls.should match_array @payrolls
  end

  it "should not get other's payroll" do
    account = Account.new(:employee_id => 1, :name_chn => "张三", :name_eng => "Zhang,San")

    Payroll.should_receive(:find_all_by_employee_id).with(account.employee_id).and_return(nil)

    my_payrolls = account.my_payrolls
    my_payrolls.should be_nil
  end
end