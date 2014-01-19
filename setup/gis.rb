#!/usr/bin/env ruby
require 'pg'
require 'yaml'

config = YAML.load_file('../config/config.yml')
DATABASE = {
  'host' => config['process']['db_host'],
  'user' => config['process']['db_user'],
  'pass' => config['process']['db_pass'],
  'name' => config['process']['db_name']
}

db = PG.connect(:host => DATABASE['host'], :dbname => DATABASE['name'], :user => DATABASE['user'], :password => DATABASE['pass'])
db.prepare('insert_coord', "update firms set coord=ST_GeomFromEWKT(ST_SetSRID(ST_MakePoint($3, $2), 4326)) where firm_id=$1")

db.exec('select firm_id, lat, lng from firms') do |result|
  result.each do |row|
    values = [row.values_at('firm_id')[0], row.values_at('lat')[0], row.values_at('lng')[0]]
    db.exec_prepared('insert_coord', values)
  end
end