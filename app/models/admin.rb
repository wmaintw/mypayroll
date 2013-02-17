class Admin < ActiveRecord::Base
  attr_accessible :ip, :last_login, :password, :username
end
