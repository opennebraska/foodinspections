require 'sinatra/base'
require 'sinatra/config_file'
require './lib/yelp'

# /api/yelp/*
class YelpApi < Sinatra::Base
  @@enabled = false
  @@consumer_key = ''
  @@consumer_secret = ''
  @@token = ''
  @@token_secret = ''
  
  def self.enabled=(is_enabled)
    @@enabled = is_enabled
  end
  
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
  
  before do
    # Ensure this API is even enabled
    if not @@enabled
      halt 403, {'Content-Type' => 'text/plain'}, 'Yelp support disabled'
    end
    
    # Disallow remote access to authenticated third-party APIs
    if not '127.0.0.1' == request.ip.to_s
      halt 403, {'Content-Type' => 'text/plain'}, 'Access denied'
    end
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