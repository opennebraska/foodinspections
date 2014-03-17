#!/bin/bash
echo "if [ ! -f ~/.installedrvm ]; then" >> ~vagrant/.profile
echo "  echo 'Installing RVM and Ruby 2.1.1'" >> ~vagrant/.profile
echo "  curl -L https://get.rvm.io | bash -s stable --auto-dotfiles >/dev/null && source ~/.rvm/scripts/rvm && rvm install --default 2.1.1 >/dev/null && gem install bundler >/dev/null" >> ~vagrant/.profile
echo "  echo 'Installing gems for Food Inspection'" >> ~vagrant/.profile
echo "  cd /src && bundle install >/dev/null" >> ~vagrant/.profile
echo "  echo 'Gems installed'" >> ~vagrant/.profile
echo "  echo 'Installing PostgreSQL gem (pg)'" >> ~vagrant/.profile
echo "  gem install pg" >> ~vagrant/.profile
echo "  echo 'pg gem installed'" >> ~vagrant/.profile
echo "  echo 'Adding PostGIS POINTs to the database'" >> ~vagrant/.profile
echo "  cd /src/setup && ruby ./gis.rb" >> ~vagrant/.profile
echo "  echo 'PostGIS POINTs added'" >> ~vagrant/.profile
echo "  touch ~/.installedrvm" >> ~vagrant/.profile
echo "fi" >> ~vagrant/.profile
echo "source ~/.rvm/scripts/rvm" >> ~vagrant/.profile
