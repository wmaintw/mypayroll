class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :username
      t.string :password
      t.datetime :last_login
      t.string :ip

      t.timestamps
    end
  end
end
