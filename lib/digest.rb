module Digest
  def digest_string(message)
    digest = Digest::SHA2.new
    digest.hexdigest(message)
  end
end