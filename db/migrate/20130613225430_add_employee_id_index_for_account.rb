class AddEmployeeIdIndexForAccount < ActiveRecord::Migration
  def change
    add_index :accounts, [:employee_id], :unique => true
  end
end
