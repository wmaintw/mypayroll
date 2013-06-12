require 'securerandom'

task :load_accounts => :environment do
  begin
    filename = 'accounts.txt'
    f = File.open(filename)
    lines = f.readlines
    total_count = lines.length
    index = 0

    lines.each do |line|
      process_account(line)

      index += 1
      update_progress(index, total_count)
    end

  ensure
    close_file(f)
  end
end

task :clear_accounts => :environment do
  Account.delete_all
  puts "all accounts deleted."
end

def account_exist?(employee_id)
  Account.find_by_employee_id(employee_id).nil?
end

def generate_email(employee_id)
  "#{employee_id}@thoughtworks.com"
end

def generate_password
  SecureRandom.base64 5
end

def close_file(f)
  f.close unless f.nil?
end

def create_account(employee_id, name_chn, name_eng)
  account = Account.new
  account.employee_id = employee_id
  account.name_chn = name_chn
  account.name_eng = name_eng
  account.temp_password = generate_password()
  account.email = generate_email(employee_id)
  account.active = false
  account.save
end

def parse_account(line)
  fields = line.split("_")
  {:employee_id => fields[0],
   :name_chn => fields[1],
   :name_eng => fields[2]}
end

def process_account(line)
  account = parse_account(line)

  unless account_exist?(account[:employee_id])
    puts "account #{account[:name_chn]} already exist, so skip."
    return
  end

  create_account(account[:employee_id], account[:name_chn], account[:name_eng])
end

def update_progress(index, total_count)
  puts "#{index} / #{total_count} account processed."
end