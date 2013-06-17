class ModifyPayrollColumns < ActiveRecord::Migration
  def change
    add_column :payrolls, :months_ticket_in_payroll, :decimal
    add_column :payrolls, :four_insure_base, :decimal
    add_column :payrolls, :total_deduction, :decimal

    remove_column :payrolls, :social_security_adjustment
    remove_column :payrolls, :pension_base
    remove_column :payrolls, :total_allowances
  end
end
