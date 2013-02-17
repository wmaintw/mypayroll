class Account < ActiveRecord::Base
  has_many :payrolls
  attr_accessible :active, :email, :name, :password
end
