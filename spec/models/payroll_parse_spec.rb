# encoding: UTF-8

require 'spec_helper'

describe Payroll do
  before do
    Payroll.delete_all
    @payroll_file = Rails.root.join("spec/fixtures/test-payroll.xls")
    @payroll_file_updated = Rails.root.join("spec/fixtures/test-payroll-updated.xls")
    @payroll_file_another_month = Rails.root.join("spec/fixtures/test-payroll-another-month.xls")
    @payroll_for_month_feb = "2013-02-01"
    @payroll_for_month_jan = "2013-01-01"
  end

  it "should parse payroll" do
    parsed_payrolls = Payroll.parse(@payroll_file)
    parsed_payrolls.count.should == 3
  end

  it "should parse payroll details" do
    parsed_payrolls = Payroll.parse(@payroll_file)

    parsed_payrolls.count.should > 0
    payroll = parsed_payrolls[0]
    payroll.number.should == 20
    payroll.name_chn.should == "马伟"
    payroll.name_eng.should == "Ma,Wei"
    payroll.period.to_s.should == "2013-04-04T00:00:00+00:00"
    payroll.current_annual_salary.should == 100000
    payroll.salary.should == 7142.86
    payroll.base_salary.should == 6142.86
    payroll.total_allowance.should == 1000
    payroll.reimbursement_shall.should == 1
    payroll.domestic_travel_allowance.should == 2
    payroll.overseas_travel_allowance.should == 3
    payroll.months_ticket_in_payroll.should == 4
    payroll.annual_leave_not.should == 5
    payroll.bonus.should == 6
    payroll.others.should == 7
    payroll.increase_the_total.should == 28
    payroll.salary_total.should == 7170.86
    payroll.basis_of_housing_fund.should == 12957
    payroll.housing_fund.should == 1555
    payroll.social_security_base.should == 11957
    payroll.four_insure_base.should == 8
    payroll.pension.should == 956.56
    payroll.unemploy.should == 23.91
    payroll.medical.should == 242.14
    payroll.sub_total_for_individual.should == 2777.61
    payroll.salary_before_tax.should == 4393.25
    payroll.tax_deductable_exp.should == 3500
    payroll.taxable_income.should == 893.25
    payroll.individual_income_tax.should == 26.8
    payroll.net_pay.should == 4366.45
    payroll.reimbursement_shall_deduction.should == 1
    payroll.domestic_travel_allowance_deduction.should == 2
    payroll.overseas_travel_allowance_deduction.should == 3
    payroll.receivables_deduction.should == 4
    payroll.computer_update_deduction.should == 5
    payroll.anniversary_gift_deduction.should == 6
    payroll.others_deduction.should == 7
    payroll.total_deduction.should == 28
    payroll.real_net_pay.should == 4338.45
  end

  it "should parse and save payroll" do
    payroll_file = Rack::Test::UploadedFile.new(@payroll_file, "application/vnd.ms-excel", false)
    Payroll.parse_to_database!(payroll_file, @payroll_for_month_feb)

    retrieved_payroll = Payroll.find_by_name_chn "马伟"

    retrieved_payroll.name_chn.should == "马伟"
    retrieved_payroll.name_eng.should == "Ma,Wei"
    retrieved_payroll.current_annual_salary.should == 100000

    retrieved_payroll = Payroll.find_by_name_chn "不存在"
    retrieved_payroll.should == nil
  end

  it "should update payroll if payroll already exist" do
    Payroll.count.should == 0

    payroll_file = Rack::Test::UploadedFile.new(@payroll_file, "application/vnd.ms-excel", false)
    payroll_file_updated = Rack::Test::UploadedFile.new(@payroll_file_updated, "application/vnd.ms-excel", false)
    Payroll.parse_to_database!(payroll_file, @payroll_for_month_feb)

    Payroll.count.should == 3
    retrieved_payroll = Payroll.find_by_name_chn "马伟"
    retrieved_payroll.should_not == nil
    retrieved_payroll.current_annual_salary.should == 100000

    Payroll.parse_to_database!(payroll_file_updated, @payroll_for_month_feb)

    Payroll.count.should == 3
    retrieved_updated_payroll = Payroll.find_by_name_chn "马伟"
    retrieved_updated_payroll.should_not == nil

    retrieved_updated_payroll.current_annual_salary.should == 110000
  end

  it "should insert payroll for each month" do
    payroll_file = Rack::Test::UploadedFile.new(@payroll_file, "application/vnd.ms-excel", false)
    payroll_file_another_month = Rack::Test::UploadedFile.new(@payroll_file_another_month, "application/vnd.ms-excel", false)

    Payroll.parse_to_database!(payroll_file, @payroll_for_month_feb)
    Payroll.count.should == 3

    Payroll.parse_to_database!(payroll_file_another_month, @payroll_for_month_jan)
    Payroll.count.should == 6
  end
end
