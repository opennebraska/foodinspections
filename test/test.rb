ENV['RACK_ENV'] = 'test'

#require './lib/inspections'
require 'test/unit'
#require 'rack/test'

class Tests < Test::Unit::TestCase
#  include Rack::Test::Methods
  
  def placeholder
    assert true
  end
  
#  def app
#    Sinatra::Application
#  end
#  
#  def something_loads
#    get '/'
#    assert last_response.ok?
#  end
end
