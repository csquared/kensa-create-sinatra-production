require 'capybara/dsl'
require_relative 'rack_test_case'

class IntegrationTestCase < RackTestCase
  include Capybara::DSL

  def setup
    super
    stub_request(:get, "https://nav.heroku.com/v1/providers/header")
    Capybara.app = App
  end

  def teardown
    super
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
