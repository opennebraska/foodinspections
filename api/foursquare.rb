require 'sinatra/base'
require 'sinatra/config_file'
require './lib/foursquare'

class FoursquareApi < Sinatra::Base
  @@client_id = ''
  @@client_secret = ''
  
  def self.id=(new_id)
    @@client_id = new_id
  end
  
  def self.secret=(new_secret)
    @@client_secret = new_secret
  end
  
  # Limit access to the server
  before do
    if not '127.0.0.1' == request.ip.to_s
      halt 403, {'Content-Type' => 'text/plain'}, 'Access denied'
    end
  end
  
  get '/search/:lat/:lng/:name' do
    client = FoursquareClient.new(@@client_id, @@client_secret)
    client.search(params[:lat], params[:lng], params[:name])
  end
end