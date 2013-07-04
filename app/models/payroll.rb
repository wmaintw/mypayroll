require "poi"

class Payroll < ActiveRecord::Base
  belongs_to :account
  attr_accessible :name_chn, :name_eng, :number, :anniversary_gift_deduction, :annual_leave_not, :base_salary,
                  :basis_of_housing_fund, :bonus, :computer_update_deduction, :current_annual_salary,
                  :domestic_travel_allowance, :domestic_travel_allowance_deduction, :housing_fund,
                  :increase_the_total, :individual_income_tax, :medical, :net_pay, :others, :others_deduction,
                  :overseas_travel_allowance, :overseas_travel_allowance_deduction, :pension,
                  :period, :real_net_pay, :receivables_deduction, :reimbursement_shall,
                  :reimbursement_shall_deduction, :salary, :salary_before_tax, :salary_total,
                  :social_security_base, :sub_total_for_individual, :tax_deductable_exp, :taxable_income,
                  :total_allowance, :unemploy, :payroll_for_month, :employee_id, :months_ticket_in_payroll,
                  :four_insure_base, :total_deduction
  accepts_nested_attributes_for :account

  class << self
    OFFICE_LOCATIONS = ["BJ", "XA", "CD", "SH"]

    def parse(payroll_file)
      book = POI::Workbook.open payroll_file
      payroll_index_starts_from = 2
      payrolls = []

      OFFICE_LOCATIONS.each do |location|
        sheet = book.worksheets[location]
        next if sheet.nil?

        sheet.rows.each_with_index do |row, index|
          next if index < payroll_index_starts_from
          payroll_row = parse_each_payroll_row(row)
          payrolls << payroll_row unless payroll_row.employee_id.nil?
        end
      end

      payrolls
    end

    def parse_to_database!(uploaded_payroll_file, payroll_for_month)
      temp_payroll_file = Rails.root.join('payroll/temp-payroll.xls')
      payroll_date = Date.parse(payroll_for_month)
      result = nil

      begin
        write_to_temp_file(uploaded_payroll_file, temp_payroll_file)

        self.parse(temp_payroll_file).each do |payroll|
          payroll.payroll_for_month = payroll_date
          save_payroll(payroll)
        end

        result = true
      rescue
        result = false
      ensure
        delete(temp_payroll_file) unless temp_payroll_file.nil?
      end

      result
    end

    private

    def save_payroll(parsed_payroll)
      exist_payroll = find_exist_payroll(parsed_payroll)
      if exist_payroll != nil
        update_payroll(exist_payroll, parsed_payroll)
      else
        parsed_payroll.save
      end
    end

    def find_exist_payroll(parsed_payroll)
      Payroll.find_by_employee_id_and_payroll_for_month(parsed_payroll.employee_id,
                                                        parsed_payroll.payroll_for_month)
    end

    def update_payroll(exist_payroll, parsed_payroll)
      parsed_payroll.attributes.each do |key, value|
        exist_payroll[key] = value unless no_need_to_update(key)
      end
      exist_payroll.save
    end

    def no_need_to_update(key)
      no_need_to_update_attributes = ["id", "account_id", "created_at", "updated_at"]
      no_need_to_update_attributes.include? key
    end

    def parse_each_payroll_row(row)
      payroll = Payroll.new

      PAYROLL_ATTRIBUTES.each do |key, index|
        next if row[index].cell_type == POI::Cell::CELL_TYPE_ERROR

        if row[index].cell_type == POI::Cell::CELL_TYPE_FORMULA
          next if row[index].formula_value == POI::Cell::CELL_TYPE_ERROR

          payroll[key] = row[index].value
        else
          payroll[key] = row[index].value
        end
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

  def my_payroll?(employee_id, name_chn)
    return false if self.employee_id.nil? or self.name_chn.nil?
    return false if employee_id.nil? or name_chn.nil?

    self.employee_id.eql?(employee_id) and self.name_chn.eql?(name_chn)
  end

  PAYROLL_ATTRIBUTES = {
      "number" => 0,
      "employee_id" => 4,
      "name_chn" => 5,
      "name_eng" => 6,
      "period" => 7,
      "current_annual_salary" => 12,
      "salary" => 13,
      "base_salary" => 14,
      "total_allowance" => 15,
      "reimbursement_shall" => 16,
      "domestic_travel_allowance" => 17,
      "overseas_travel_allowance" => 18,
      "months_ticket_in_payroll" => 19,
      "annual_leave_not" => 20,
      "bonus" => 21,
      "others" => 22,
      "increase_the_total" => 23,
      "salary_total" => 24,
      "basis_of_housing_fund" => 25,
      "housing_fund" => 26,
      "social_security_base" => 27,
      "four_insure_base" => 28,
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
      "total_deduction" => 45,
      "real_net_pay" => 46
  }

end
