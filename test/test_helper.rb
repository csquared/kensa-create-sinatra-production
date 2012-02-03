ENV['DATABASE_URL']    = 'postgres://localhost/myaddon-test'
ENV['HEROKU_USERNAME'] = 'addon'
ENV['HEROKU_PASSWORD'] = 'pw'
ENV['RACK_ENV']        = 'test'
ENV['SSO_SALT']        = 'salt'

require 'test/unit'
Bundler.require :test

require_relative '../app'
require_relative 'rack_test_case'
require_relative 'integration_test_case'

APP_ROOT = File.expand_path('../..', __FILE__) + '/'

Fabrication.configure do |config|
  fabricator_dir = APP_ROOT + "test/fabricators"
end
