require 'bundler'
require 'net/http'
require 'sinatra'
require 'sinatra/config_file'
require 'sass'
require 'json'
require 'data_mapper'
require './helpers/init'
require './models/init'
require './api/init'
Bundler.require

set :environments, %w{process development production}
config_file 'config/config.yml'

# Turn on DataMapper logging in development mode
configure :development do
  DataMapper::Logger.new($stdout, :debug)
end

# Database setup
db_url = 'postgres://' + settings.db_user + ':' + settings.db_pass + '@' + settings.db_host + '/' + settings.db_name
DataMapper.setup(:default, db_url)

# CartoDB setup
carto_settings = {
  'host' => settings.cartodb_host,
  'api_key' => settings.cartodb_apikey
}
CartoDB::Init.start carto_settings


# get '/css/*.css' do
#   content_type 'text/css', :charset => 'utf-8'
#   scss params[:splat].join.to_sym, :style => :compressed
# end

get '/' do
  erb :index
end