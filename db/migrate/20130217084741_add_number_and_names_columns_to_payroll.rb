class AddNumberAndNamesColumnsToPayroll < ActiveRecord::Migration
  def change
    add_column :payrolls, :number, :integer
    add_column :payrolls, :name_chn, :string
    add_column :payrolls, :name_eng, :string
  end
end
