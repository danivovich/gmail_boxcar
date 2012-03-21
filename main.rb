require 'rubygems'
require 'bundler/setup'

require 'set'
require 'boxcar_api'
require 'gmail'
require 'active_support/all'

POLL_INTERVAL = ENV['POLL_INTERVAL'] || 30

def get_account_info
  accounts = {}
  count = ENV['ACCOUNT_COUNT'] || 1
  count = count.to_i
  if count == 1
    acounts[ENV['GMAIL_USERNAME']] = ENV['GMAIL_PASSWORD']
    NOTIFY_ACCOUNT = ENV['GMAIL_USERNAME']
  else
    count.times do |i|
      acounts[ENV["GMAIL_USERNAME_#{i}"]] = ENV["GMAIL_PASSWORD_#{i}"]
    end
    NOTIFY_ACCOUNT = ENV['GMAIL_USERNAME_0']
  end
  accounts
end

username_password_hash = get_account_info
unless username_password_hash.length > 0
  puts 'GMAIL_USERNAME and GMAIL_PASSWORD env variables are not set'
  exit
end

boxcar_key = ENV['BOXCAR_KEY']
boxcar_secret = ENV['BOXCAR_SECRET']
unless boxcar_key.present? && boxcar_secret.present?
  puts 'BOXCAR_KEY and BOXCAR_SECRET env variables are not set'
  exit
end


while true
  username_password_hash.each_pair do |username, password|
    puts "Checking #{username} gmail"
    gmail = Gmail.new(username, password)
    emails = gmail.inbox.emails(:unread)
    emails.each do |e|
      from = e.from.first.name
      msg = e.subject
      puts "  #{from}: #{msg}"
      provider = BoxcarAPI::Provider.new(boxcar_key, boxcar_secret)
      provider.notify(NOTIFY_ACCOUNT, msg,
        :from_screen_name => from,
        :from_remote_service_id => e.uid)
    end
    gmail.logout
    puts 'Done checking, sleeping now'
    $stdout.flush
  end
  sleep POLL_INTERVAL
end
