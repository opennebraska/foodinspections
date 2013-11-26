#!/usr/bin/env ruby
require 'csv'
require 'json'
require 'Tempfile'

INPUTFILE = 'State_restaurant_inspections.csv'
OUTPUTFILE = 'cartodb_import.csv'
LOGFILE = 'json.log'

def hackyescape(str)
  return str.gsub('"', "'")
end

File.open(LOGFILE, 'w') do |log|
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
    unless last_paren.nil?
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
    else
      ret = {
        'address' => cell_text,
        'lat' => 0,
        'lng' => 0
      }
      return ret
    end
  end

  processed = 0
  firms = {}
  CSV.foreach(INPUTFILE, :headers => true) do |row|
    unless firms.has_key?(row[0])
      firms[row[0]] = {
        'firm_id' => row[0],
        'name' => row[1].to_s,
        'parent' => row[2].to_s,
        'location' => getfirmlocation(row[11].to_s),
        'total_critical' => 0,
        'total_noncritical' => 0,
        'inspection_count' => 0,
        'inspections' => []
      }
    end
  
    # Up our counts
    firms[row[0]]['inspection_count'] += 1
    firms[row[0]]['total_critical'] += row[7].to_i
    firms[row[0]]['total_noncritical'] += row[8].to_i
  
    # Add the new inspection
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
    firms[row[0]]['inspections'].push(new_inspection)
  
    log.puts "Processed #{processed}: Firm(#{row[0].to_s}), Date(#{row[4].to_s})"
    processed += 1
  end

  firms.each do |firm|
    json_filename = 'data/' + firm[1]['firm_id'].to_s + '.json'
    File.open(json_filename, 'w') do |f|
      f.puts JSON.generate(firm[1])
    end
    log.puts "Generated #{json_filename}"
  end
end
