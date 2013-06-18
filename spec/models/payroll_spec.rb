# encoding: UTF-8

require 'spec_helper'

describe Payroll do
  before do
    Payroll.delete_all
  end

  it "should return true given payroll is for current account" do
    account = Account.new(:name_chn => "张三", :employee_id => 1)
    payroll = Payroll.create({:name_chn => "张三", :employee_id => 1, :salary => 2000, :payroll_for_month => "2013-01-01"})

    result = payroll.my_payroll? account.employee_id, account.name_chn

    result.should be_true
  end

  it "should return false given payroll and account miss matched with employee id" do
    account = Account.new(:name_chn => "张三", :employee_id => 11)
    payroll = Payroll.create({:name_chn => "张三", :employee_id => 22, :salary => 2000, :payroll_for_month => "2013-01-01"})

    result = payroll.my_payroll? account.employee_id, account.name_chn

    result.should be_false
  end

  it "should return false given payroll and account miss matched with chinese name" do
    account = Account.new(:name_chn => "张三", :employee_id => 1)
    payroll = Payroll.create({:name_chn => "李四", :employee_id => 1, :salary => 2000, :payroll_for_month => "2013-01-01"})

    result = payroll.my_payroll? account.employee_id, account.name_chn

    result.should be_false
  end

  it "should return false given payroll is incorrect" do
    account = Account.new(:name_chn => "张三", :employee_id => 1)

    payroll_1 = Payroll.create({:name_chn => "张三", :employee_id => nil, :salary => 2000, :payroll_for_month => "2013-01-01"})
    result = payroll_1.my_payroll? account.employee_id, account.name_chn
    result.should be_false

    payroll_2 = Payroll.create({:name_chn => nil, :employee_id => 1, :salary => 2000, :payroll_for_month => "2013-01-01"})
    result = payroll_2.my_payroll? account.employee_id, account.name_chn
    result.should be_false

    payroll_3 = Payroll.create({:name_chn => nil, :employee_id => nil, :salary => 2000, :payroll_for_month => "2013-01-01"})
    result = payroll_3.my_payroll? account.employee_id, account.name_chn
    result.should be_false
  end

  it "should return false given current account is incorrect" do
    payroll = Payroll.create({:name_chn => "张三", :employee_id => 1, :salary => 2000, :payroll_for_month => "2013-01-01"})

    account_1 = Account.new(:name_chn => nil, :employee_id => 1)
    result = payroll.my_payroll? account_1.employee_id, account_1.name_chn
    result.should be_false

    account_2 = Account.new(:name_chn => "张三", :employee_id => nil)
    result = payroll.my_payroll? account_2.employee_id, account_2.name_chn
    result.should be_false

    account_3 = Account.new(:name_chn => nil, :employee_id => nil)
    result = payroll.my_payroll? account_3.employee_id, account_3.name_chn
    result.should be_false
  end

  it "should return false given both payroll and account is incorrect" do
    account = Account.new(:name_chn => nil, :employee_id => nil)
    payroll = Payroll.create({:name_chn => nil, :employee_id => nil, :salary => 2000, :payroll_for_month => "2013-01-01"})

    result = payroll.my_payroll? account.employee_id, account.name_chn

    result.should be_false
  end
end