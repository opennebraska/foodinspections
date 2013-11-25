#!/usr/bin/env ruby
require 'csv'

INPUTFILE = 'State_restaurant_inspections.csv'

firms = {}
CSV.foreach(INPUTFILE, :headers => true) do |row|
  unless(firms.has_key? row[0])
    firms[row[0]] = {
      'firm_id' => row[0],
      'critical' => 0,
      'noncritical' => 0
    }
  end
  firms[row[0]]['critical'] += row[7].to_i
  firms[row[0]]['noncritical'] += row[8].to_i
end

File.open('violations3.csv', 'w') do |f|
  firms.values.each do |d|
    text = d['firm_id'] + ',' + d['critical'].to_s + ',' + d['noncritical'].to_s + "\n"
    f << text
    puts text
  end
end
