Nebraska Food Inspections
=========================

This repository contains code created at HO3 (Hack Omaha III: Hack with a Vengeance). It's a huge work in progress right now.

We ([Ross](http://twitter.com/rossnelson) and [Dustin](http://twitter.com/tacktaco)) will be working in the near future on getting our first real version of it done. We have plans beyond that, such as removing a dependency on a third party database and adding reviews from various social sites, but for now we simply want to get a version up and running.

If you want to start hacking on it, our current setup is roughly as follows:

1. Create two CartoDB accounts
2. Use `setup/gencarto1.rb` to generate the first CSV, which contains (firm ID, name, parent name, latitude, longitude, PostGIS POINT field)
3. Use `setup/gencarto2.rb` to generate the second CSV, which contains the violation data
4. Create a table on each CartoDB instance, one for each generated CSV. In the first, set `the_geometry` to use the imported latitude and longitude
5. Modify `js/geo.js` to use your own API keys (yes, those are real ones; we'll be generating new ones and not sharing them shortly)
6. Hope it works

Good luck.