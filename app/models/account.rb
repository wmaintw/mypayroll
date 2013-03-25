class Account < ActiveRecord::Base
  has_many :payrolls
  attr_accessible :active, :email, :name, :password

  class << self


    def payrolls(account_name)
      Payroll.find_all_by_name_chn account_name, {:order => "payroll_for_month desc"}
    end
  end
end
