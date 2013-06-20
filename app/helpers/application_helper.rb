module ApplicationHelper
  def empty_field?(field)
    field.nil? or field.eql?("")
  end
end
