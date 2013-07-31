require 'sinatra'
require 'sinatra/namespace'

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
  if current_user
    slim :dashboard
  else
    redirect to('/')
  end
end

get '/sign_up' do
  if current_user
    redirect to('/dashboard')
  else
    slim :signup
  end
end

post %r{/(user|api)/sign_in} do
  content_type :json
  user = User.where(email: params[:email]).first
  if user = User.authenticate(params[:email], params[:password])
    session[:user_id] = user.id
    success_info user
  else
    fail_info message: "Login error", status: 404
  end
end

namespace %r{/(user|api)} do

  post '/sign_up' do
    content_type :json
    unless params_has_key :email, :password
      return fail_info message: "Invalid arguments", status: 401
    end
    unless User.where(email: params[:email]).count == 0
      user = User.new email: params[:email],
        password: params[:password]
      if user.save
        session[:user_id] = user.id
        success_info user
      else
        fail_info message: "Server error", status: 500
      end
    else
      fail_info message: "User exists", status: 401
    end
  end

  get '/sign_out' do
    session[:user_id] = nil
  end

  get '/:id' do
    content_type :json
    if user = User.where(id: params[:id]).first
      success_info user
    else
      fail_info status: 404
    end
  end
  
end

namespace '/api' do

  get '/user/:id/courses' do
  end

  get '/courses' do
  end

  get '/course/:id' do
  end

  post '/courses' do
  end

  delete '/course/:id' do
  end
  
  put '/course/:id' do
  end
  
  get '/course/:id/schedules' do
  end
  
  post '/course/:id/schedules' do
  end
  
  delete '/schedule/:id' do
  end
  
  put '/schedule/:id' do
  end
  

end


# Internal: check if the params hash has the specified key
#
# - args: array of keys to be checked
#
# Returns true if every key in the argument exists in params hash
def params_has_key *args
  args.each do |key|
    unless params.has_key? key.to_s
      return false
    end
  end
  return true
end

# Internal: use session[:user_id] to fetch user model
# 
# Return the current user model
def current_user
  begin
    if @current_user.nil?
      return @current_user
    else
      if session[:user_id]
        return @current_user = User.find(session[:user_id])
      else
        return nil
      end
    end
  rescue
    return nil
  end
end

def success_info user,options={}
  { success: true, user_id: user.id, user: user }.merge(options).
    to_json(except: :password_hash)
end

def fail_info options={}
  { success: false, user_id: session[:user_id] }.merge(options).to_json
end
