#!/usr/bin/env ruby
require 'csv'
require 'json'
require 'Tempfile'

INPUTFILE = 'State_restaurant_inspections.csv'
OUTPUTFILE = 'cartodb_import.csv'

def hackyescape(str)
  return str.gsub('"', "'")
end

#########################################################
# Output all of the (firm_id, name, lat, long) pairs to #
# a separate file to import them into CartoDB           #
#########################################################

# Read in the entire inspections file
data = []
CSV.foreach(INPUTFILE, :headers => true) do |row|
  if row[11].end_with?(')')
    # Get the firm ID
    fid = row[0]
    
    # Get the business name
    name = hackyescape(row[1])
    
    # Get the parent company name
    parent_name = hackyescape(row[2].to_s)
    
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

# Find unique (firm_id, lat, long) pairs and spit those out to a temp file
uniq_data = data.uniq
File.open(OUTPUTFILE, 'w') do |f|
  uniq_data.each do |entry|
    f.puts entry
  end
end



#########################################################
# Create individual JSON files for each of the          #
# locations                                             #
#########################################################

firm_ids = []

def getfirmlocation(cell_text)
  ### Latitude/longitude
  # Get just the coordinate part
  last_paren = cell_text.rindex('(')
  coords = cell_text[last_paren+1..-1]

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
  
  ### Street/City/State
  last_paren = cell_text.rindex('(')
  mailing_address = cell_text[0..last_paren-2]
  
  # State
  last_comma = mailing_address.rindex(',')
  state = mailing_address[last_comma+1..-0]
  
  ret = {
    'address' => mailing_address,
    'lat' => new_lat,
    'lng' => new_lng
  }
  return ret
end

CSV.foreach(OUTPUTFILE) do |row|
  if not row[0].nil?
    firm_ids.push(row[0].to_i)
  end
end

firm_ids.each do |firm_id|
  did_this_one = false
  firm_obj = {
    'firm_id' => firm_id,
    'name' => '',
    'parent' => '',
    'location' => {
      'address' => '',
      'lat' => nil,
      'lng' => nil
    },
    'inspection_count' => 0,
    'inspections' => Array.new()
  }
  
  CSV.foreach(INPUTFILE, :headers => true) do |row|
    if row[0].to_i == firm_id and row[11].strip.end_with?(')')
      location_string = row[11]
      loc = getfirmlocation(location_string)

      if not did_this_one
        firm_obj['name'] = row[1].to_s
        firm_obj['parent'] = row[2].to_s
        firm_obj['location'] = getfirmlocation(row[11].to_s)

        did_this_one = true
      end
  
      # Add a new inspection
      firm_obj['inspection_count'] += 1
      new_inspection = {
        'date' => row[4],
        'facod' => row[5],
        'inspection_type' => row[6],
        'violations' => {
          'critical' => row[7],
          'noncritical' => row[8]
        },
        'followup' => row[9],
        'inspector_number' => row[10]
      }
      firm_obj['inspections'].push(new_inspection)
    end
  end
  
  json_filename = 'data/' + firm_id.to_s + '.json'
  File.open(json_filename, 'w') do |f|
    f.puts JSON.generate(firm_obj)
  end
end