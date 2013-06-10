class Account < ActiveRecord::Base
  has_many :payrolls
  attr_accessible :active, :email, :name, :password, :name_chn, :name_eng, :employee_id, :temp_password

  class << self
    def payrolls(account_name_chn, account_name_eng)
      Payroll.find_all_by_name_chn_and_name_eng account_name_chn, account_name_eng,
                                                {:order => "payroll_for_month desc"}
    end
  end
end
