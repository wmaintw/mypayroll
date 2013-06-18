class Account < ActiveRecord::Base
  include Digest
  has_many :payrolls
  attr_accessible :active, :email, :name, :password, :name_chn, :name_eng, :employee_id, :temp_password

  class << self
    def payrolls(account_name_chn, account_name_eng)
      Payroll.find_all_by_name_chn_and_name_eng account_name_chn, account_name_eng,
                                                {:order => "payroll_for_month desc"}
    end
  end

  def change_password(old_password, new_password1, new_password2)
    return false unless new_password1.eql?(new_password2)
    return false unless self.password.eql?(digest_string(old_password))

    encrypted_new_password = digest_string(new_password1)
    result = self.update_column(:password, encrypted_new_password)
    if result == true
      self.password = encrypted_new_password
    end
    return result
  end

  def my_payrolls
    Payroll.find_all_by_employee_id_and_name_chn self.employee_id, self.name_chn, {:order => "payroll_for_month desc"}
  end
end
