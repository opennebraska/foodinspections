#!/usr/bin/env ruby
require 'csv'
require 'pg'
require 'yaml'

# Read the config file
config = YAML.load_file('../config/config.yml')

# Set our constants
INPUTFILE = config['process']['input_file']
OUTPUTFILE = config['process']['output_file']
DATABASE = {
  'host' => config['process']['db_host'],
  'user' => config['process']['db_user'],
  'pass' => config['process']['db_pass'],
  'name' => config['process']['db_name']
}


# # aptitude install postgresql-9.1-postgis
# # su - postgres
# postgres=# create database inspections;
# postgres=# grant all privileges on database inspections to ho3;
# postgres=# \q
# $ psql --username=postgres --dbname=inspections --file=/usr/share/postgresql/9.1/contrib/postgis-1.5/postgis.sqlpostgres@ho3db:~$ psql --username=postgres --dbname=inspections --file=/usr/share/postgresql/9.1/contrib/postgis-1.5/spatial_ref_sys.sql
# $ psql -d inspections
# inspections=# GRANT Truncate, Insert, Select, Delete, Trigger, References, Update ON TABLE "public"."spatial_ref_sys" TO "ho3";
# inspections=# GRANT Truncate, Insert, Select, Delete, References, Trigger, Update ON TABLE "public"."geometry_columns" TO "ho3";
# inspections=# \q
# $
# $ exit


# drop table if exists firms;
# drop table if exists inspections;
# create table firms (id serial primary key, firm_id bigint, name varchar(255), parent_name varchar(255), total_critical integer, total_noncritical integer, address varchar(255), lat real, lng real);
# create table inspections (id serial primary key, firm_id bigint, inspection_date date, inspection_type integer, business_type integer, critical_violations integer, noncritical_violations integer, followup boolean, inspector_number integer);
# --select AddGeometryColumn("coord", 4326, "POINT", 2);
# create index latlng_index on firms (lat, lng);




def hackeyescape(str)
  return str.gsub('"', "'")
end

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




#########################################################
# Output all of the (firm_id, lat, long) pairs to #
# a separate file to import them into CartoDB           #
#########################################################

# Read in the entire inspections file
data = []
CSV.foreach(INPUTFILE, :headers => true) do |row|
  if row[11].end_with?(')')
    # Firm ID
    fid = row[0]
    
    # Coordinate string
    last_paren = row[11].rindex('(')
    coords = row[11][last_paren+1..-1]
    
    # Lat and long
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

# Find unique (firm_id, lat, long) pairs and spit
# those out to a CartoDB input file
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
CSV.foreach(OUTPUTFILE) do |row|
  if not row[0].nil?
    firm_ids.push(row[0].to_i)
  end
end

# Connect to the database
db = PG.connect(:host => DATABASE['host'],
  :dbname => DATABASE['name'],
  :user => DATABASE['user'],
  :password => DATABASE['pass']
)
db.prepare('insert_firm', 'insert into firms(firm_id, name, parent_name, total_critical, total_noncritical, address, lat, lng) values ($1, $2, $3, $4, $5, $6, $7, $8)')
db.prepare('insert_inspection', 'insert into inspections(firm_id, inspection_date, inspection_type, business_type, critical_violations, noncritical_violations, followup, inspector_number) values ($1, $2, $3, $4, $5, $6, $7, $8)')

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
    'total_critical' => 0,
    'total_noncritical' => 0,
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
        'facod' => row[5].to_i,
        'inspection_type' => row[6].to_i,
        'violations' => {
          'critical' => row[7].to_i,
          'noncritical' => row[8].to_i
        },
        'followup' => row[9].to_i == 2 ? false : true,
        'inspector_number' => row[10]
      }
      firm_obj['total_critical'] += row[7].to_i
      firm_obj['total_noncritical'] += row[8].to_i
      firm_obj['inspections'].push(new_inspection)
    end
  end
  
  db.exec_prepared('insert_firm', [
    firm_obj['firm_id'],
    firm_obj['name'],
    firm_obj['parent'],
    firm_obj['total_critical'],
    firm_obj['total_noncritical'],
    firm_obj['location']['address'],
    firm_obj['location']['lat'],
    firm_obj['location']['lng']
  ])
  
  firm_obj['inspections'].each do |inspection|
    db.exec_prepared('insert_inspection', [
      firm_obj['firm_id'],
      inspection['date'],
      inspection['inspection_type'],
      inspection['facod'],
      inspection['violations']['critical'],
      inspection['violations']['noncritical'],
      inspection['followup'],
      inspection['inspector_number']
    ])
  end
end
