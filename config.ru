Dir.glob("./{helpers,lib}/*.rb").each { |file| require file }

map '/' do
  run Inspections
end

map '/api/v1' do
  run ApiV1
end

map '/api/foursquare' do
  run FoursquareApi
end