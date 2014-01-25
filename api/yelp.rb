require 'sinatra/base'
require 'sinatra/config_file'
require './api/apibase'
require './lib/yelp'

# /api/yelp/*
# Display requirements: http://www.yelp.com/developers/getting_started/display_requirements
class YelpApi < ApiBase
  @@consumer_key = ''
  @@consumer_secret = ''
  @@token = ''
  @@token_secret = ''
    
  def self.consumer_key=(new_consumer_key)
    @@consumer_key = new_consumer_key
  end
  
  def self.consumer_secret=(new_consumer_secret)
    @@consumer_secret = new_consumer_secret
  end
  
  def self.token=(new_token)
    @@token = new_token
  end
  
  def self.token_secret=(new_token_secret)
    @@token_secret = new_token_secret
  end
  
  def get_client
    return YelpClient.new(@@consumer_key, @@consumer_secret, @@token, @@token_secret)
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