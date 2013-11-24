#!/usr/bin/env ruby
require 'csv'
require 'json'
require 'Tempfile'

# Read in the entire inspections file
data = []
CSV.foreach('inspections.csv') do |row|
  if row[11].end_with?(')')
    # Get the firm ID
    fid = row[0]
    
    # Get just the coordinate part
    last_paren = row[11].rindex('(')
    coords = row[11][last_paren+1..-1]
    
    # Grab lat and long
    lat = coords.split(',')[0]
    lng = coords.split(',')[1]
    
    # Truncate latitude
    period = lat.index('.')
    last_char = period + 5
    new_lat = lat[0..last_char]
    
    # Truncate longitude
    period = lng.index('.')
    last_char = period + 5
    new_lng = lng[0..last_char]
    
    # Add a new data point
    data_point = fid + ',' + new_lat + ',' + new_lng
    data.push(data_point)
  end
end

# Find unique (firm_id, lat, long) pairs and spit those out to a temp file
uniq_data = data.uniq
#tmp = Tempfile.new('uniqdata')
uniq_data.each do |entry|
  puts entry
#  tmp << entry
end
#tmp.flush
#tmp.close

