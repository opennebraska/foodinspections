require 'bundler'
require 'sinatra/base'
require 'sinatra/config_file'
require 'sass'
require 'json'
require 'data_mapper'
require './helpers/init'
require './models/init'
require './api/init'
Bundler.require

class Inspections < Sinatra::Base
  register Sinatra::ConfigFile
  
  configure do
    set :app_file, __FILE__
    set :run, true
    set :server, %w[thin mongrel webrick]
    set :cookie_options, { path: '/' }
    set :sessions, true
    set :root, File.join(File.dirname(__FILE__), '../')
  end
  
  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
    also_reload 'helpers/**/*.rb'
    also_reload 'models/**/*.rb'
    also_reload 'api/**/*.rb'
    set :raise_errors, true
    
    DataMapper::Logger.new($stdout, :debug)
  end
  
  # Load the user's config file
  set :environments, %w{process development production}
  config_file 'config/config.yml'
  
  # Database setup
  db_url = 'postgres://' + settings.db_user + ':' + settings.db_pass + '@' + settings.db_host + '/' + settings.db_name
  DataMapper.setup(:default, db_url)
  
  # CartoDB setup
  carto_settings = {
    'host' => settings.cartodb_host,
    'api_key' => settings.cartodb_apikey
  }
  CartoDB::Init.start carto_settings
  
  error do
    halt 500, 'Server error'
  end
  not_found do
    halt 404, 'File not found'
  end
  
  #get '/css/*.css' do
  #  content_type 'text/css', :charset => 'utf-8'
  #  path = "../public/css/#{params[:splat].join}"
  #  scss path.to_sym, :style => :compressed
  #end
  
  get '/' do
    erb :index
  end
end
