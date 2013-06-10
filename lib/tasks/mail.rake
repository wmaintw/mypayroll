task :send_activate_mail => :environment do
  accounts = find_all_inactive_accounts()
  send_active_mail(accounts)
end

def find_all_inactive_accounts
  accounts = Account.find_all_by_active false
  puts "#{accounts.length} inactive account found."

  return accounts
end

def send_active_mail(accounts)
  total_count = accounts.length
  index = 0

  accounts.each do |account|
    AccountMailer.activate_account(account).deliver

    index += 1
    puts "#{index} / #{total_count}, mail to #{account.name_chn} has been sent."
  end
end