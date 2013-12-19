#!/bin/bash

if [ -x ~/.rvm/scripts/rvm ]; then
  source ~/.rvm/scripts/rvm
else
  if [ -x /usr/local/rvm/scripts/rvm ]; then
    source /usr/local/rvm/scripts/rvm
  fi
fi

unicorn -c config/unicorn.rb -D -E production
