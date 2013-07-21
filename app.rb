require 'sinatra'

require_relative "config/environment/#{settings.environment}"
Dir['./config/*.rb'].each {|f| require f}
Dir['./helpers/*.rb'].each {|f| require f}
Dir['./models/*.rb'].each {|f| require f}
Dir['./lib/*.rb'].each {|f| require f}

Mongoid.load! "./config/mongoid.yml"

get '/' do
  slim :index
end
