
# Deploying to Heroku

`heroku create --stack cedar`

`heroku config:add GMAIL_USERNAME="..."`

`heroku config:add GMAIL_PASSWORD="..."`

`heroku config:add BOXCAR_KEY="..."`

`heroku config:add BOXCAR_SECRET="..."`

`git push heroku master`

`heroku ps:scale worker=1`

