require 'sinatra/base'
require 'sinatra/config_file'
require './lib/foursquare'

# /api/foursquare/*
class FoursquareApi < Sinatra::Base
  @@enabled = false
  @@client_id = ''
  @@client_secret = ''
  
  def self.enabled=(is_enabled)
    @@enabled = is_enabled
  end
  
  def self.id=(new_id)
    @@client_id = new_id
  end
  
  def self.secret=(new_secret)
    @@client_secret = new_secret
  end
  
  before do
    # Ensure this API is even enabled
    if not @@enabled
      halt 403, {'Content-Type' => 'text/plain'}, 'Foursquare support disabled'
    end
    
    # Disallow remote access to authenticated third-party APIs
    if not '127.0.0.1' == request.ip.to_s
      halt 403, {'Content-Type' => 'text/plain'}, 'Access denied'
    end
  end
  
  get '/v1/search/:lat/:lng/:name' do
    client = FoursquareClient.new(@@client_id, @@client_secret)
    client.search(params[:lat], params[:lng], params[:name])
  end
  
  get '/v1/venues/:id' do
    client = FoursquareClient.new(@@client_id, @@client_secret)
    client.venue_info(params[:id])
  end
end