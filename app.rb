require_relative 'env'

class App < Sinatra::Base
  use Rack::Session::Cookie, secret: ENV['SSO_SALT']

  helpers do
    def protected!
      unless authorized?
        response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
        throw(:halt, [401, "Not authorized\n"])
      end
    end

    def authorized?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? && @auth.basic? && @auth.credentials && 
      @auth.credentials == [ENV['HEROKU_USERNAME'], ENV['HEROKU_PASSWORD']]
    end

    def json_body
      @json_body ||= JSON.parse(request.body.read)
    end

    def resource(id = nil)
      id ||= params[:id]
      Resource.first(:id => id).tap do |resource|
        halt 404 unless resource
      end
    end
  end

  error 503 do
    content_type 'application/json'
    {message: @message}.to_json
  end
  
  # sso landing page
  get "/" do
    halt 403, 'not logged in' unless session[:heroku_sso]
    @resource = resource(session[:resource])
    @email    = session[:email]
    @saved    = session[:saved] and session[:saved] = nil
    haml :index
  end

  def sso
    pre_token = params[:id] + ':' + ENV['SSO_SALT'] + ':' + params[:timestamp]
    token = Digest::SHA1.hexdigest(pre_token).to_s
    halt 403 if token != params[:token]
    halt 403 if params[:timestamp].to_i < (Time.now - 2*60).to_i

    session[:resource]   = params[:id]
    response.set_cookie('heroku-nav-data', value: params['nav-data'])
    session[:heroku_sso] = params['nav-data']
    session[:email]      = params[:email]

    redirect '/'
  end

  post "/heroku/resources/:id/update" do
    redirect "/"
  end
  
  post "/heroku/resources/:id/events" do
  end
  
  # sso sign in
  get "/heroku/resources/:id" do
    sso
  end

  post '/sso/login' do
    sso
  end

  # provision
  post '/heroku/resources' do
    protected!
    begin
      plan, hid, options = json_body['plan'], json_body['heroku_id'], json_body['options']
      resource = Resource.create(plan: plan, heroku_id: hid, options: options)
      Log.provision_success "hid=#{hid} resource_id=#{resource.id}" 

      status 201
      content_type 'application/json'
      {id: resource.id}.to_json
    rescue StandardError => e
      Log.provision_fail error: e.class, message: e.message, hid: hid, plan: plan
      @message = e.message and halt 503
    end
  end

  # deprovision
  delete '/heroku/resources/:id' do
    protected!
    resource.update(plan: 'inactive')
    "ok"
  end

  # plan change
  put '/heroku/resources/:id' do
    protected!  
    resource.update(plan: json_body['plan'])
    "ok"
  end
end
