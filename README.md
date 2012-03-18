# What is this?

I started using [Sparrow](http://sparrowmailapp.com/iphone.php) for email on my 
iPhone, but it does not support (for very good security reasons) push email 
notification.

I wanted to see if I could write something that would let me know when I had new 
email so I could open Sparrow and check it.  By hosting it myself on 
[Heroku](http://www.heroku.com/) I wouldn't need to share my email credentials 
with anyone else, nor forward my email to Boxcar in order to have their email 
triggered notifications notify me (as suggested by the Sparrow FAQ)

The end result is a simple app that wakes every 30 seconds (configurable) and 
connects to Gmail looking for unread email that it hasn't seen since it started 
(for now).  If emails are found, a message is sent to the Boxcar account of the 
email used to connect to Gmail.

# Deploying to Heroku

Designed to run with [Foreman](https://github.com/ddollar/foreman), can easily 
be deployed to Heroku with a single worker dyno.

`heroku create --stack cedar`

Setup config params for Gmail and Boxcar

`heroku config:add GMAIL_USERNAME="..."`

`heroku config:add GMAIL_PASSWORD="..."`

`heroku config:add BOXCAR_KEY="..."`

`heroku config:add BOXCAR_SECRET="..."`

Deploy

`git push heroku master`

Start the worker

`heroku ps:scale worker=1`

Check the logs

`heroku logs`

