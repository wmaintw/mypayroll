class AddTempPasswordColumn < ActiveRecord::Migration
  def change
    add_column :accounts, :temp_password, :string
  end
end
