require 'oauth'

class YelpClient
  attr_accessor :consumer_key, :consumer_secret, :token, :token_secret
  attr_accessor :api_host
  
  def initialize(key, secret, token, token_secret)
    @consumer_key = key
    @consumer_secret = secret
    @token = token
    @token_secret = token_secret
    
    # Set up the consumer and access token here and use them for the
    # life of this client instance. The API generates a new client
    # for each call.
    consumer = OAuth::Consumer.new(@consumer_key, @consumer_secret, {:site => 'http://api.yelp.com'})
    @oauth = OAuth::AccessToken.new(consumer, @token, @token_secret)
  end
  
  def near(lat, lng, radius=1609)
    latlng = lat.to_s + ',' + lng.to_s
    url = build_url({'ll' => latlng, 'radius_filter' => radius.to_s})
    
    return @oauth.get(url).body
  end
  
  def search(lat, lng, query, radius=1609)
    latlng = lat.to_s + ',' + lng.to_s
    url = build_url({'ll' => latlng, 'term' => CGI::escape(query), 'radius_filter' => radius.to_s})
    
    p url
    consumer = OAuth::Consumer.new(@consumer_key, @consumer_secret, {:site => "http://api.yelp.com"})
    oauth = OAuth::AccessToken.new(consumer, @token, @token_secret)
    return oauth.get(url).body
  end
  
  def build_url(arg_map)
    url = '/v2/search?'
    
    if not arg_map.nil?
      arg_map.each do |k, v|
        #url += CGI::escape(k) + '=' + CGI::escape(v) + '&'
        url += k + '=' + v + '&'
        end
    end
    
    # Add some constants
    url += 'deals_filter=false'
    
    return url
  end
end