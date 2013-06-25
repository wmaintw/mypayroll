class SetupPayrollDatabase < ActiveRecord::Migration
  def change

    create_table "accounts", :force => true do |t|
      t.string   "email"
      t.string   "password"
      t.boolean  "active"
      t.datetime "created_at",                   :null => false
      t.datetime "updated_at",                   :null => false
      t.string   "name_chn"
      t.string   "name_eng"
      t.integer  "employee_id",   :limit => 255
      t.string   "temp_password"
    end

    add_index "accounts", ["employee_id"], :name => "index_accounts_on_employee_id", :unique => true

    create_table "admins", :force => true do |t|
      t.string   "username"
      t.string   "password"
      t.datetime "last_login"
      t.string   "ip"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    create_table "payrolls", :force => true do |t|
      t.integer  "account_id"
      t.date     "period"
      t.decimal  "current_annual_salary"
      t.decimal  "salary"
      t.decimal  "base_salary"
      t.decimal  "total_allowance"
      t.decimal  "reimbursement_shall"
      t.decimal  "domestic_travel_allowance"
      t.decimal  "overseas_travel_allowance"
      t.decimal  "annual_leave_not"
      t.decimal  "bonus"
      t.decimal  "others"
      t.decimal  "increase_the_total"
      t.decimal  "salary_total"
      t.decimal  "basis_of_housing_fund"
      t.decimal  "housing_fund"
      t.decimal  "social_security_base"
      t.decimal  "pension"
      t.decimal  "unemploy"
      t.decimal  "medical"
      t.decimal  "sub_total_for_individual"
      t.decimal  "salary_before_tax"
      t.decimal  "tax_deductable_exp"
      t.decimal  "taxable_income"
      t.decimal  "individual_income_tax"
      t.decimal  "net_pay"
      t.decimal  "reimbursement_shall_deduction"
      t.decimal  "domestic_travel_allowance_deduction"
      t.decimal  "overseas_travel_allowance_deduction"
      t.decimal  "receivables_deduction"
      t.decimal  "computer_update_deduction"
      t.decimal  "anniversary_gift_deduction"
      t.decimal  "others_deduction"
      t.decimal  "real_net_pay"
      t.datetime "created_at",                                         :null => false
      t.datetime "updated_at",                                         :null => false
      t.integer  "number"
      t.string   "name_chn"
      t.string   "name_eng"
      t.date     "payroll_for_month"
      t.integer  "employee_id",                         :limit => 255
      t.decimal  "months_ticket_in_payroll"
      t.decimal  "four_insure_base"
      t.decimal  "total_deduction"
    end

    add_index "payrolls", ["account_id"], :name => "index_payrolls_on_account_id"

  end
end
