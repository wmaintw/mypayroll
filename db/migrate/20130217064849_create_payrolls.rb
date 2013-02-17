class CreatePayrolls < ActiveRecord::Migration
  def change
    create_table :payrolls do |t|
      t.references :account
      t.date :period
      t.decimal :current_annual_salary
      t.decimal :salary
      t.decimal :base_salary
      t.decimal :total_allowance
      t.decimal :reimbursement_shall
      t.decimal :domestic_travel_allowance
      t.decimal :overseas_travel_allowance
      t.decimal :social_security_adjustment
      t.decimal :annual_leave_not
      t.decimal :bonus
      t.decimal :others
      t.decimal :increase_the_total
      t.decimal :salary_total
      t.decimal :basis_of_housing_fund
      t.decimal :housing_fund
      t.decimal :pension_base
      t.decimal :social_security_base
      t.decimal :pension
      t.decimal :unemploy
      t.decimal :medical
      t.decimal :sub_total_for_individual
      t.decimal :salary_before_tax
      t.decimal :tax_deductable_exp
      t.decimal :taxable_income
      t.decimal :individual_income_tax
      t.decimal :net_pay
      t.decimal :reimbursement_shall_deduction
      t.decimal :domestic_travel_allowance_deduction
      t.decimal :overseas_travel_allowance_deduction
      t.decimal :receivables_deduction
      t.decimal :computer_update_deduction
      t.decimal :anniversary_gift_deduction
      t.decimal :others_deduction
      t.decimal :total_allowances
      t.decimal :real_net_pay

      t.timestamps
    end
    add_index :payrolls, :account_id
  end
end
