module ApplicationHelper
  def digest_string(message)
    digest = Digest::SHA2.new
    digest.hexdigest(message)
  end

  def empty_field?(field)
    field.nil? or field.eql?("")
  end

  def week_password?(password)
    return true if password.length < 8

    false
  end
end
