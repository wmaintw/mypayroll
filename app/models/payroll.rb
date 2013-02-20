require "spreadsheet"

class Payroll < ActiveRecord::Base
  belongs_to :account
  attr_accessible :name_chn, :name_eng, :number, :anniversary_gift_deduction, :annual_leave_not, :base_salary, :basis_of_housing_fund, :bonus, :computer_update_deduction, :current_annual_salary, :domestic_travel_allowance, :domestic_travel_allowance_deduction, :housing_fund, :increase_the_total, :individual_income_tax, :medical, :net_pay, :others, :others_deduction, :overseas_travel_allowance, :overseas_travel_allowance_deduction, :pension, :pension_base, :period, :real_net_pay, :receivables_deduction, :reimbursement_shall, :reimbursement_shall_deduction, :salary, :salary_before_tax, :salary_total, :social_security_adjustment, :social_security_base, :sub_total_for_individual, :tax_deductable_exp, :taxable_income, :total_allowance, :total_allowances, :unemploy
  accepts_nested_attributes_for :account

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

    def parse_to_database!(uploaded_payroll_file)
      temp_payroll_file = Rails.root.join('payroll/temp-payroll.xls')
      begin
        write_to_temp_file(uploaded_payroll_file, temp_payroll_file)

        self.parse(temp_payroll_file).each do |payroll|
          save_payroll(payroll)
        end

        delete(temp_payroll_file)
        true
      rescue
        false
      end
    end

    private

    def save_payroll(parsed_payroll)
      exist_payroll = Payroll.find_by_name_chn(parsed_payroll.name_chn)
      if exist_payroll != nil
        update_payroll(exist_payroll, parsed_payroll)
      else
        parsed_payroll.save
      end
    end

    def update_payroll(exist_payroll, parsed_payroll)
      updated_payroll_attributes = {}
      parsed_payroll.attributes.each do |key, value|
        updated_payroll_attributes[key] = value unless no_need_to_update(key)
      end
      exist_payroll.update_attributes updated_payroll_attributes
    end

    def no_need_to_update(key)
      no_need_to_update_attributes = ["id", "account_id", "created_at", "updated_at"]
      no_need_to_update_attributes.include? key
    end

    def parse_each_payroll_row(row)
      payroll = Payroll.new

      PAYROLL_ATTRIBUTES.each do |key, index|
        payroll[key] = row[index]
      end

      payroll
    end

    def delete(payroll_file)
      File.delete(payroll_file)
    end

    def write_to_temp_file(upload_payroll_file, temp_file)
      File.open(temp_file, 'wb') do |file|
        file.write(upload_payroll_file.read)
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
