class Admin < ActiveRecord::Base
  include ApplicationHelper

  attr_accessible :ip, :last_login, :password, :username

  def change_password(old_password, new_password1, new_password2)
    return false unless new_password1.eql?(new_password2)
    return false unless self.password.eql?(digest_string(old_password))
    return false if empty_field?(new_password1) or empty_field?(new_password2)
    return false if week_password?(new_password1)

    encrypted_new_password = digest_string(new_password1)
    result = self.update_column(:password, encrypted_new_password)
    if result == true
      self.password = encrypted_new_password
    end
    return result
  end
end
