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

notified = Set.new

while true
  puts "Checking gmail"
  gmail = Gmail.new(username, password)
  emails = gmail.inbox.emails(:unread)
  count = emails.count { |e| !notified.include?(e.uid) }
  puts "Found #{count} unread emails"
  if count > 0
    provider = BoxcarAPI::Provider.new(boxcar_key, boxcar_secret)
    provider.notify(username, "You have #{count} unread emails")
  end
  emails.each { |e| notified.add(e.uid) }
  gmail.logout
  puts "Done checking, sleeping now"
  $stdout.flush
  sleep POLL_INTERVAL
end
