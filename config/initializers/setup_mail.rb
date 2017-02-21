ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address:        'smtp.sendgrid.net',
  port:           '2525',
  authentication: :plain,
  user_name:      ENV['app64048922@heroku.com'],
  password:       ENV['mrclgmsy4616'],
  domain:         'heroku.com',
  enable_starttls_auto: true
}
