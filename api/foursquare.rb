require 'sinatra/base'
require 'sinatra/config_file'
require './api/apibase'
require './lib/foursquare'

# /api/foursquare/*
class FoursquareApi < ApiBase
  get '/v1/search/:lat/:lng/:name' do
    client = FoursquareClient.new(@@creds[:client_id], @@creds[:client_secret])
    client.search(params[:lat], params[:lng], params[:name])
  end
  
  get '/v1/venues/:id' do
    client = FoursquareClient.new(@@creds[:client_id], @@creds[:client_secret])
    client.venue_info(params[:id])
  end
end