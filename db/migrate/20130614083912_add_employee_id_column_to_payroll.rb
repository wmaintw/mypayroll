class AddEmployeeIdColumnToPayroll < ActiveRecord::Migration
  def change
    add_column :payrolls, :employee_id, :string
  end
end
