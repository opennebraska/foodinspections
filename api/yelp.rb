require 'sinatra/base'
require 'sinatra/config_file'
require './api/apibase'
require './lib/yelp'

# /api/yelp/*
# Display requirements: http://www.yelp.com/developers/getting_started/display_requirements
class YelpApi < ApiBase
  def get_client
    return YelpClient.new(@@creds[:consumer_key], @@creds[:consumer_secret], @@creds[:token], @@creds[:token_secret])
  end
  
  get '/v1/search/:lat/:lng/:name' do
    client = get_client
    client.search(params[:lat], params[:lng], params[:name])
  end
  
  get '/v1/search/:lat/:lng/:name/:radius' do
    client = get_client
    client.search(params[:lat], params[:lng], params[:name], params[:radius])
  end
end