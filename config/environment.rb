# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Mypayroll::Application.initialize!

#Action Mailer Settings
ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = false
ActionMailer::Base.raise_delivery_errors = true

ActionMailer::Base.smtp_settings = {
    :address => "smtp.qq.com",
    :port => 25,
    :domain => "www.qq.com",
    :authentication => :login,
    :user_name => "mypayroll@qq.com",
    :password => "@Ctive@705"
}

