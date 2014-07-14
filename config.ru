Dir.glob("./{helpers,lib}/*.rb").each { |file| require file }

require 'unicorn/worker_killer'
use Unicorn::WorkerKiller::Oom, (192*(1024**2)), (256*(1024**2))

map '/' do
  run Inspections
end

map '/api/v1' do
  run ApiV1
end

map '/api/foursquare' do
  run FoursquareApi
end

map '/api/yelp' do
  run YelpApi
end
