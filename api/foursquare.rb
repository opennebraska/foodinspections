require 'sinatra/base'
require 'sinatra/config_file'
require './api/apibase'
require './lib/foursquare'

# /api/foursquare/*
class FoursquareApi < ApiBase
  @@client_id = ''
  @@client_secret = ''
  
  def self.id=(new_id)
    @@client_id = new_id
  end
  
  def self.secret=(new_secret)
    @@client_secret = new_secret
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