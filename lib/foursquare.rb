require 'net/http'
require 'uri'

class FoursquareClient
  attr_accessor :client_id, :client_secret
  
  def initialize(id, secret)
    @client_id = id
    @client_secret = secret
    
    @@api_version = '20140101'
    @@api_root = 'https://api.foursquare.com/v2/'
  end
  
  def get_root
    return @@api_root
  end
  
  def get_creds
    return {'client_id' => @client_id, 'client_secret' => @client_secret}
  end
  
  def near(lat, lng)
    latlng = lat + ',' + lng
    params = build_query({'ll' => latlng})
    
    uri = URI(@@api_root + 'venues/search')
    uri.query = URI.encode_www_form(params)
    
    res = Net::HTTP.get_response(uri).body
  end
  
  def search(lat, lng, query)
    latlng = lat + ',' + lng
    params = build_query({'ll' => latlng, 'query' => query})
    
    uri = URI(@@api_root + 'venues/search')
    uri.query = URI.encode_www_form(params)
    
    res = Net::HTTP.get_response(uri)
    return res.body #if res.is_a?(Net::HTTPSuccess)
  end
  
  def venue_info(venue_id)
    params = build_query(nil)
    
    uri = URI(@@api_root + '/venues/' + venue_id.to_s)
    uri.query = URI.encode_www_form(params)
    
    res = Net::HTTP.get_response(uri)
    return res.body
  end
  
  def build_query(arg_map)
    query = get_creds
    query['v'] = @@api_version
    
    if not arg_map.nil?
      arg_map.each do |k, v|
        query[k] = v
        end
    end
    
    return query
  end
end