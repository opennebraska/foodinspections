#!/bin/bash
echo "if [ ! -f ~/.installedrvm ]; then" >> ~vagrant/.profile
echo "  curl -L https://get.rvm.io | bash -s stable && source ~/.rvm/scripts/rvm && rvm install --default 2.1 && gem install bundler" >> ~vagrant/.profile
echo "  touch ~/.installedrvm" >> ~vagrant/.profile
echo "fi" >> ~vagrant/.profile
