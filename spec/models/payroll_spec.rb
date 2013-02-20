# encoding: UTF-8

require 'spec_helper'

describe Payroll do
  before do
    @payroll_file = Rails.root.join("spec/fixtures/test-payroll.xls")
    @payroll_file_updated = Rails.root.join("spec/fixtures/test-payroll-updated.xls")
  end

  it "should parse payroll" do
    parsed_payrolls = Payroll.parse(@payroll_file)
    parsed_payrolls.count.should == 3
  end

  it "should parse payroll details" do
    parsed_payrolls = Payroll.parse(@payroll_file)

    parsed_payrolls.count.should > 0
    payroll = parsed_payrolls[0]
    payroll.number.should == 18
    payroll.name_chn.should == "马伟"
    payroll.name_eng.should == "Ma,Wei"
    payroll.period.to_s.should == "2012-11-12"
    payroll.current_annual_salary.should == 1000
    payroll.salary.should == 1001
    payroll.base_salary.should == 1005
    payroll.total_allowance.should == 1006
    payroll.reimbursement_shall.should == 1007
    payroll.domestic_travel_allowance.should == 1008
    payroll.overseas_travel_allowance.should == 1009
    payroll.social_security_adjustment.should == 1010
    payroll.annual_leave_not.should == 1011
    payroll.bonus.should == 1012
    payroll.others.should == 1013
    payroll.increase_the_total.should == 1014
    payroll.salary_total.should == 1015
    payroll.basis_of_housing_fund.should == 1016
    payroll.housing_fund.should == 1017
    payroll.pension_base.should == 1018
    payroll.social_security_base.should == 1019
    payroll.pension.should == 1020
    payroll.unemploy.should == 1021
    payroll.medical.should == 1022
    payroll.sub_total_for_individual.should == 1023
    payroll.salary_before_tax.should == 1024
    payroll.tax_deductable_exp.should == 1025
    payroll.taxable_income.should == 1026
    payroll.individual_income_tax.should == 1027
    payroll.net_pay.should == 1028
    payroll.reimbursement_shall_deduction.should == 1029
    payroll.domestic_travel_allowance_deduction.should == 1030
    payroll.overseas_travel_allowance_deduction.should == 1031
    payroll.receivables_deduction.should == 1032
    payroll.computer_update_deduction.should == 1033
    payroll.anniversary_gift_deduction.should == 1034
    payroll.others_deduction.should == 1035
    payroll.total_allowances.should == 1036
    payroll.real_net_pay.should == 1037
  end

  it "should parse and save payroll" do
    payroll_file = Rack::Test::UploadedFile.new(@payroll_file, "application/vnd.ms-excel", false)
    Payroll.parse_to_database!(payroll_file)

    retrieved_payroll = Payroll.find_by_name_chn "马伟"

    retrieved_payroll.name_chn.should == "马伟"
    retrieved_payroll.name_eng.should == "Ma,Wei"
    retrieved_payroll.current_annual_salary.should == 1000
    retrieved_payroll.salary.should == 1001
    retrieved_payroll.base_salary.should == 1005

    retrieved_payroll = Payroll.find_by_name_chn "不存在"
    retrieved_payroll.should == nil
  end

  it "should update payroll if payroll already exist" do
    Payroll.count.should == 0

    payroll_file = Rack::Test::UploadedFile.new(@payroll_file, "application/vnd.ms-excel", false)
    payroll_file_updated = Rack::Test::UploadedFile.new(@payroll_file_updated, "application/vnd.ms-excel", false)
    Payroll.parse_to_database!(payroll_file)

    Payroll.count.should == 3
    retrieved_payroll = Payroll.find_by_name_chn "马伟"
    retrieved_payroll.should_not == nil
    retrieved_payroll.current_annual_salary.should == 1000

    Payroll.parse_to_database!(payroll_file_updated)

    Payroll.count.should == 3
    retrieved_payroll = Payroll.find_by_name_chn "马伟"
    retrieved_payroll.should_not == nil

    retrieved_payroll.current_annual_salary.should == 1100
  end
end
