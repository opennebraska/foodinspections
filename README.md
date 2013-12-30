Nebraska Food Inspections
=========================

This repository contains code created at HO3 ([Hack Omaha III: Hack with a Vengeance](http://www.meetup.com/Open-Nebraska-Meetup/events/149197282/)).

We have plans beyond what works now, such as removing a dependency on a third party database and adding reviews from various social sites. Work in progress. Feel free to check out [our prototype](http://foodinspections.opennebraska.io).

Getting Started
---------------

### Prerequisites

This project is written in [Ruby](https://www.ruby-lang.org) (1.9+, 2.0+ recommended) and uses [PostgreSQL](http://www.postgresql.org) (developed against 9.1). Dependency management is done with [Bundler](http://bundler.io).

If you don't currently have a Ruby environment set up, check out [RVM](http://rvm.io).

Once you have Ruby and Bundler installed, clone this repository and run `bundle install` from its root.


### Configuration

Both the `process.rb` script that helps you get data into your databases and the actual site code use `config/config.yml` as their configuration. Create this file (using `config/config.yml.example` as a guide) and customize it to your environment.


### Data

1. Create a [CartoDB](http://cartodb.com) account
2. Create the necessary tables in your database; example commands (including currently unused [PostGIS](http://postgis.net) stuff) is in `setup/process.rb`
3. Run `setup/process.rb` to generate the CartoDB CSV, which contains (firm ID, latitude, longitude), and to populate the database
4. Create a table on your CartoDB instance for the generated CSV. Set `the_geometry` to use the imported latitude and longitude


### Running

Simply run `rackup` and view the site at [http://localhost:9292](http://localhost:9292)


Credits
-------

See [CONTRIBUTORS](https://github.com/rnelson/ne_state_restaurant_inspections/blob/master/CONTRIBUTORS.md).
