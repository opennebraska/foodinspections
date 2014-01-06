#!/bin/bash
echo "Setting up the Food Inspections database"
sudo -u postgres createdb inspections
sudo -u postgres psql inspections < /src/setup/inspections.sql >/dev/null
echo "Database setup finished"