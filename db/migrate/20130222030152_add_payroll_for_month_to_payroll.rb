class AddPayrollForMonthToPayroll < ActiveRecord::Migration
  def change
    add_column :payrolls, :payroll_for_month, :date
  end
end
