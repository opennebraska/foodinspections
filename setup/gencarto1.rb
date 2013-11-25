#!/usr/bin/env ruby
require 'csv'

INPUTFILE = 'State_restaurant_inspections.csv'
OUTPUTFILE = 'ne_restaurant_inspections.csv'

def badescape(str)
  return str.gsub('"', "'")
end

# Read in the entire inspections file
data = []
CSV.foreach(INPUTFILE, :headers => true) do |row|
  if row[11].end_with?(')')
    # Get the firm ID
    fid = row[0]
    
    # Get the business name
    name = badescape(row[1])
    
    # Get the parent company name
    parent_name = badescape(row[2].to_s)
    
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
    data_point = fid + ',"' + name + '","' + parent_name + '",' + new_lat + ',' + new_lng
    data.push(data_point)
  end
end

# Find unique (firm_id, lat, long) pairs and spit those out to the first
# CartoDB input file file
uniq_data = data.uniq
File.open(OUTPUTFILE, 'w') do |f|
  uniq_data.each do |entry|
    f.puts entry
  end
end