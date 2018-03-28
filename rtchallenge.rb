# bundle exec irb -I. -r rtchallenge.rb <- not able to get this running

require 'sinatra'
require 'json'
require 'rest-client'
require 'pry'
require 'rb-readline'
require 'sinatra/activerecord'

# try to get the below working instead of requiring every gem independently
# require 'rubygems'
# require 'bundler'

#environmnet
require './config/environments'

#models
require './models/owner'
require './models/release'

#helpers
require './helpers/sprint_helpers'

#controllers
require './controllers/home_controller'
require './controllers/sprint_controller'
require './controllers/release_controller'
require './controllers/product_owners_controller'

# Bundler.require

module SprintPlanner
  class App < Sinatra::Application
    configure do
      set :static, true
    end

    use Rack::Deflater
  end
end
