Nebraska Food Inspections
=========================

This repository contains code created at HO3 ([Hack Omaha III: Hack with a Vengeance](http://www.meetup.com/Open-Nebraska-Meetup/events/149197282/)).

We have plans beyond what works now, such as removing a dependency on a third party database and adding reviews from various social sites. Work in progress. Feel free to check out [our prototype](http://foodinspections.opennebraska.io).

If you want to start hacking on it, our current setup is roughly as follows:

0. Install Ruby 2.0+, `gem install bundler`, grab the source, and from our root run `bundle install`
1. Create a CartoDB account
2. Install [PostgreSQL](http://www.postgresql.org) and create necessary tables; example commands (including currently unused [PostGIS](http://postgis.net) stuff) is in `setup/process.rb`
3. Modify `setup/process.rb` to point to your PostgreSQL install
4. Run `setup/process.rb` to generate the CartoDB CSV, which contains (firm ID, latitude, longitude), and to populate the database
5. Create a table on your CartoDB instance for the generated CSV. Set `the_geometry` to use the imported latitude and longitude
6. Create `config/cartodb.yml` with your URL and API key for CartoDB
7. Modify the database settings in `app.db`
8. Run `dev.sh` and view the site at [http://localhost:4567](http://localhost:4567)

A unicorn configuration file (`config/unicorn.rb`) is included and tailored to our production environment.

Good luck!

-[Ross](http://twitter.com/rossnelson) and [Dustin](http://twitter.com/tacktaco)