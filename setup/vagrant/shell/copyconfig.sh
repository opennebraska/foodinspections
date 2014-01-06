#!/bin/bash
if [ ! -f /src/config/config.yml ]; then
  echo "Copying sample config.yml"
  cp /src/config/config.yml.example /src/config/config.yml
fi