module ApplicationHelper
  def empty_field?(field)
    field.nil? or field.eql?("")
  end

  def week_password?(password)
    return true if password.length < 8

    false
  end
end
