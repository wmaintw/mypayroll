class AccountMailer < ActionMailer::Base
  default from: "mypayroll@qq.com"

  def activate_account(account)
    email = "#{account.employee_id}@thoughtworks.com"
    subject = "Activate your account in MyPayroll system."
    @account = account

    mail(:to => email, :subject => subject)
  end
end
