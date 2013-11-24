#!/usr/bin/env ruby
require 'rubygems'
require 'csv'
require 'pg'

db = PG.connect(:host => '15.126.244.50', :dbname => 'inspections', :user => 'ho3', :password => 'Cwth8AR+E8J84WYKQo')
data = 'State_restaurant_inspections.csv'

# Create tables
db.exec('drop table if exists data')
db.exec(
	'create table data (                   ' +
	'	id serial primary key,             ' +
	'	name varchar(255),                 ' +
	'	parent_name varchar(255),          ' +
	'	inspection_date date,              ' +
	'	inspection_type integer,           ' +
	'	business_type integer,             ' +
	'	critical_violations integer,       ' +
	'	noncritical_violations integer,    ' +
	'	followup boolean,                  ' +
	'	inspector_number integer,          ' +
	'	street varchar(255),               ' +
	'	city varchar(255),                 ' +
	'	state char(2)                     ' +
	')'
)
db.exec('select AddGeometryColumn("coord", 4326, "POINT", 2)')
