class ModifyEmployeeIdColumn < ActiveRecord::Migration
  def change
    change_column :payrolls, :employee_id, :integer
    change_column :accounts, :employee_id, :integer
  end
end
