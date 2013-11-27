require 'bundler'
require 'net/http'
require 'sass'
Bundler.require

#set :port, 80

# get '/css/*.css' do
# 	content_type 'text/css', :charset => 'utf-8'
# 	scss params[:splat].join.to_sym, :style => :compressed
# end

get '/' do
  	erb :index
end
