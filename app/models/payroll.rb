require "spreadsheet"

class Payroll < ActiveRecord::Base
  belongs_to :account
  attr_accessible :name_chn, :name_eng, :number, :anniversary_gift_deduction, :annual_leave_not, :base_salary, :basis_of_housing_fund, :bonus, :computer_update_deduction, :current_annual_salary, :domestic_travel_allowance, :domestic_travel_allowance_deduction, :housing_fund, :increase_the_total, :individual_income_tax, :medical, :net_pay, :others, :others_deduction, :overseas_travel_allowance, :overseas_travel_allowance_deduction, :pension, :pension_base, :period, :real_net_pay, :receivables_deduction, :reimbursement_shall, :reimbursement_shall_deduction, :salary, :salary_before_tax, :salary_total, :social_security_adjustment, :social_security_base, :sub_total_for_individual, :tax_deductable_exp, :taxable_income, :total_allowance, :total_allowances, :unemploy

  class << self
    def parse(payroll_file)
      book = Spreadsheet.open payroll_file
      sheet = book.worksheet 0

      payrolls = []
      payroll_index_starts_from = 2
      sheet.each payroll_index_starts_from do |row|
        payrolls << parse_each_payroll_row(row)
      end

      payrolls
    end

    def parse_each_payroll_row(row)
      payroll = Payroll.new

      PAYROLL_ATTRIBUTES.each do |key, index|
        payroll[key] = row[index]
      end

      payroll
    end

    def save(payroll)
      payroll.each do |pr|
        pr.save
      end
    end
  end

  PAYROLL_ATTRIBUTES = {
      "number" => 0,
      "name_chn" => 4,
      "name_eng" => 5,
      "period" => 6,
      "current_annual_salary" => 9,
      "salary" => 10,
      "base_salary" => 14,
      "total_allowance" => 15,
      "reimbursement_shall" => 16,
      "domestic_travel_allowance" => 17,
      "overseas_travel_allowance" => 18,
      "social_security_adjustment" => 19,
      "annual_leave_not" => 20,
      "bonus" => 21,
      "others" => 22,
      "increase_the_total" => 23,
      "salary_total" => 24,
      "basis_of_housing_fund" => 25,
      "housing_fund" => 26,
      "pension_base" => 27,
      "social_security_base" => 28,
      "pension" => 29,
      "unemploy" => 30,
      "medical" => 31,
      "sub_total_for_individual" => 32,
      "salary_before_tax" => 33,
      "tax_deductable_exp" => 34,
      "taxable_income" => 35,
      "individual_income_tax" => 36,
      "net_pay" => 37,
      "reimbursement_shall_deduction" => 38,
      "domestic_travel_allowance_deduction" => 39,
      "overseas_travel_allowance_deduction" => 40,
      "receivables_deduction" => 41,
      "computer_update_deduction" => 42,
      "anniversary_gift_deduction" => 43,
      "others_deduction" => 44,
      "total_allowances" => 45,
      "real_net_pay" => 46
  }

end
