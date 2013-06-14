class Admin < ActiveRecord::Base
  include Digest

  attr_accessible :ip, :last_login, :password, :username

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
end
