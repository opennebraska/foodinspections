require 'bundler'
require 'net/http'
require 'sinatra'
require 'sinatra/jsonp'
require 'sass'
require 'json'
require 'data_mapper'
require './helpers/init'
require './models/init'
require './api/init'
Bundler.require

configure :development do
  DataMapper::Logger.new($stdout, :debug)
  DataMapper.setup(
  	:default,
  	'postgres://ho3:"Cwth8AR+E8J84WYKQo"@15.126.244.50/inspections'
  )
end
configure :production do
  DataMapper.setup(
  	:default,
  	'postgres://ho3:"Cwth8AR+E8J84WYKQo"@15.126.244.50/inspections'
  )
end

CartoDB::Init.start YAML.load_file('config/cartodb.yml')

# get '/css/*.css' do
# 	content_type 'text/css', :charset => 'utf-8'
# 	scss params[:splat].join.to_sym, :style => :compressed
# end

get '/' do
  	erb :index
end