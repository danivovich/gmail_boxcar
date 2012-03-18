require "rubygems"
require "bundler/setup"

require 'set'
require 'boxcar_api'
require 'gmail'
require 'active_support/all'

POLL_INTERVAL = ENV['POLL_INTERVAL'] || 30

username = ENV['GMAIL_USERNAME']
password = ENV['GMAIL_PASSWORD']
boxcar_key = ENV['BOXCAR_KEY']
boxcar_secret = ENV['BOXCAR_SECRET']

unless username.present? && password.present?
  puts "GMAIL_USERNAME and GMAIL_PASSWORD env variables are not set"
  exit
end

unless boxcar_key.present? && boxcar_secret.present?
  puts "BOXCAR_KEY and BOXCAR_SECRET env variables are not set"
  exit
end


while true
  puts "Checking gmail"
  gmail = Gmail.new(username, password)
  emails = gmail.inbox.emails(:unread)
  emails.each do |e|
    from = e.from.first.name
    msg = e.subject
    puts "  #{from}: #{msg}"
    provider = BoxcarAPI::Provider.new(boxcar_key, boxcar_secret)
    provider.notify(username, msg,
      :from_screen_name => from,
      :from_remote_service_id => e.uid)
  end
  gmail.logout
  puts "Done checking, sleeping now"
  $stdout.flush
  sleep POLL_INTERVAL
end
