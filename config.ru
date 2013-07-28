require 'rubygems'
require 'bundler'
require 'sinatra'

Bundler.require :default, Sinatra::Application.environment

Slim::Engine.set_default_options tabsize: 2

use Rack::Session::Cookie,
  key: '_afterclass_fun',
  path: '/',
  expire_after: 2592000, # 30 days
  secret: 'Icannotremembersuchasecretthusitisnotneededanymore'

require './app'

map '/assets' do
  run Sinatra::Application.settings.sprockets
end

run Sinatra::Application
