require 'sinatra'
require 'sinatra/namespace'
require 'mongoid'

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

get '/sign_in' do
  if current_user
    redirect to('/dashboard')
  else
    slim :sign_in
  end
end


get '/sign_up' do
  if current_user
    redirect to('/dashboard')
  else
    slim :sign_up
  end
end

namespace '/user' do

  post '/sign_in' do
    user = User.where(email: params[:email]).first
    if user = User.authenticate(params[:email], params[:password])
      session[:user_id] = user.id
      success_json user
    else
      failed_json message: "Login error", status: 404
    end
  end

  post '/sign_up' do
    unless params_has_key :email, :password
      return failed_json message: "Invalid arguments", status: 401
    end
    unless User.where(email: params[:email]).count == 0
      user = User.new email: params[:email],
        password: params[:password]
      if user.save
        session[:user_id] = user.id
        success_json user
      else
        failed_json message: "Server error", status: 500
      end
    else
      failed_json message: "User exists", status: 401
    end
  end

  get '/sign_out' do
    session[:user_id] = nil
  end

  get '/:id' do
    if user = User.where(id: params[:id]).first
      success_json user
    else
      failed_json status: 404, message: "No such user."
    end
  end
end

namespace '/api' do
  before do
    unless current_user
      halt 401, failed_json(message: "You have to sign in to continue.")
    end
  end

  get '/user/:id/courses' do
    if user = User.where(id: params[:id]).first
      success_json user.courses
    else
      failed_json message: "No such user", status: 404
    end
  end

  get '/courses' do
    success_json current_user.courses
  end

  get '/course/:id' do
    begin
      success_json current_user.courses.find(params[:id])
    rescue
      failed_json message: "No such course", status: 404
    end
  end

  post '/courses' do
    course = current_user.courses.build(params[:course])
    if course.save
      current_user.courses << course
      success_json course
    else
      failed_json message: "Cannot create course", status: 400
    end
  end

  delete '/course/:id' do
    begin
      course = current_user.courses.find params[:id]
      course.destroy
      success_json
    rescue
      failed_json message: "Cannot delete course.", status: 400
    end
  end
  
  put '/course/:id' do
    begin
      course = current_user.courses.find params[:id]
      if course.update_attributes params[:course]
        success_json course
      else
        failed_json message: "Attribute error!", status: 400
      end
    rescue Mongoid::Errors::UnknownAttribute
      failed_json message: "Attribute error.", status: 400
    rescue
      failed_json message: "Update error: no such course.", status: 404
    end
  end
  
  get '/course/:id/schedules' do
    begin
      course = Course.find params[:id]
      success_json course.schedules
    rescue
      failed_json message: "No such course.", status: 404
    end
  end
  
  post '/course/:id/schedules' do
    begin
      course = current_user.courses.find params[:id]
      schedule = course.schedules.build params[:schedule]
      if schedule.save
        course << schedule
        success_json schedule
      else
        failed_json message: "Argument error.Schedule cannot be created.", status: 400
      end
    rescue
      failed_json message: "No such course", status: 404
    end
  end
  
  delete '/schedule/:id' do
    begin
      schedule = Schedule.find params[:id]
      if schedule.destroy
        success_json
      else
        failed_json message: "Cannot delete this schedule.", status: 500
      end
    rescue
      failed_json message: "No such schedule.", status: 404
    end
  end
  
  put '/schedule/:id' do
    begin
      schedule = Schedule.find params[:id]
      if schedule.update_attributes params[:schedule]
        success_json schedule
      else
        failed_json message: "Attribute error.", status: 400
      end
    rescue Mongoid::Errors::UnknownAttribute
      failed_json message: "Attribute error.", status: 400
    rescue
      failed_json message: "No such schedule.", status: 404
    end
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
    unless @current_user.nil?
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

def success_json model=nil, options={}
  content_type :json
  { success: true, user_id: session[:user_id], data: model }.merge(options).
    to_json(except: :password_hash)
end

def failed_json options={}
  content_type :json
  if options[:status]
    status options[:status].to_i
  end
  { success: false, user_id: session[:user_id] }.merge(options).to_json
end
