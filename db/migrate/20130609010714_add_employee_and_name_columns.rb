class AddEmployeeAndNameColumns < ActiveRecord::Migration
  def change
    add_column :accounts, :name_chn, :string
    add_column :accounts, :name_eng, :string
    add_column :accounts, :employee_id, :string
  end
end
