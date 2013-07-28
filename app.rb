require 'sinatra'

Dir['./config/*.rb'].each {|f| require f}
Dir['./helpers/*.rb'].each {|f| require f}
Dir['./models/*.rb'].each {|f| require f}
Dir['./lib/*.rb'].each {|f| require f}

Mongoid.load! "./config/mongoid.yml"

require 'sinatra/asset_pipeline'

set :assets_js_compressor, :yui

register Sinatra::AssetPipeline

require_relative "config/environment/#{settings.environment}"

get '/' do
  if current_user
    redirect to('/dashboard')
  else
    slim :index
  end
end

get 'dashboard' do
  slim :dashboard
end

get '/signup' do
  if current_user
    redirect to('/dashboard')
  else
    slim :signup
  end
end

post '/api/signin' do
  content_type :json
  binding.pry
  user = User.where(email: params[:email]).first
  if user.password == params[:password]
    success_info user
  else
    fail_info message: "Login error"
  end
end

post '/api/signup' do
  content_type :json
  binding.pry
  unless User.where(email: params[:email]).first
    user = User.new email: params[:email],
      password: params[:password]
    if user.save
      success_info user
    else
      fail_info
    end
  else
    fail_info message: "User exists"
  end
end

def current_user
  if session[:user_id]
    User.find(session[:user_id])
  else
    nil
  end
end

def success_info user,options={}
  { success: true, user_id: user.id }.merge(options).to_json
end

def fail_info options={}
  { success: false, user_id: nil }.merge(options).to_json
end
