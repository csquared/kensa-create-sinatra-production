class RackTestCase < Test::Unit::TestCase
  include Rack::Test::Methods
  include RR::Adapters::TestUnit

  def app
    App
  end

  def teardown
    WebMock.reset!
    Mail::TestMailer.deliveries.clear
  end
  
  def run(*args, &block)
    Sequel::Model.db.transaction(:rollback=>:always){super}
  end

  def last_mail
    Mail::TestMailer.deliveries.last
  end

  def assert_json
    assert_match /application\/json/, last_response.headers['Content-type']
  end

  def json_body
    assert_json
    JSON.parse(last_response.body)
  end

  def basic_auth!
    authorize ENV['HEROKU_USERNAME'], ENV['HEROKU_PASSWORD']
  end

  def post_event(resource, options = {})
    post "/heroku/resources/#{resource.id}/events",
      { 
        'event'     => options.fetch(:event, 'deploy'),
        'detail'    => options.fetch(:detail, {})
      }.to_json
  end

  def sso!(id)
    timestamp = Time.now.to_i.to_s
    pre_token = id.to_s + ':' + ENV['SSO_SALT'] + ':' + timestamp
    token = Digest::SHA1.hexdigest(pre_token).to_s
    visit("/heroku/resources/#{id}?token=#{token}&timestamp=#{timestamp}&nav-data=fudge&email=foo%40bar.com")
  end

  def provision!(data = nil)
    data ||= @provision_data || provision_data
    post '/heroku/resources', data.to_json, "CONTENT_TYPE" => 'application/json'
  end

  def provision_data
    {
      plan:         'test', 
      heroku_id:    'app123@heroku.com',
      callback_url: 'http://heroku.com/app123%40heroku.com',
      options:      {}
    }
  end

  def deprovision!(id)
    delete "/heroku/resources/#{id}"
  end
end
