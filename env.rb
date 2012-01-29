require 'bundler'
Bundler.require

STDOUT.sync = true
$QC_DATABASE_URL = ENV['DATABASE_URL']

Sequel.connect ENV['DATABASE_URL']
require_relative 'lib/models/resource'

require_relative 'lib/omega_logger'
Log = OmegaLogger.new(ENV['LOG'] =~ /off|false/i ? File.open('/dev/null', 'w') : STDOUT)

Mail.defaults do
  delivery_method :smtp, { :address   => "smtp.sendgrid.net",
                           :port      => 587,
                           :domain    => "deploy-hooks.heroku.com",
                           :user_name => ENV['SMTP_USERNAME'],
                           :password  => ENV['SMTP_PASSWORD'],
                           :authentication => 'plain',
                           :enable_starttls_auto => true }
end
