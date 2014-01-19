#!/bin/bash
echo "Setting up the Food Inspections database"
sudo -u postgres createdb inspections
sudo -u postgres psql inspections < /src/setup/inspections.sql >/dev/null
echo "Setting up PostGIS on the database"
su -c 'psql -d inspections --file=/usr/share/postgresql/9.1/contrib/postgis-1.5/postgis.sql' postgres
su -c 'psql -d inspections --file=/usr/share/postgresql/9.1/contrib/postgis-1.5/spatial_ref_sys.sql' postgres
su -c 'psql -d inspections -c "GRANT Truncate, Insert, Select, Delete, Trigger, References, Update ON TABLE public.spatial_ref_sys TO inspections_user"' postgres
su -c 'psql -d inspections -c "GRANT Truncate, Insert, Select, Delete, References, Trigger, Update ON TABLE public.geometry_columns TO inspections_user"' postgres
su -c "psql -d inspections -c \"SELECT AddGeometryColumn('firms', 'coord', 4326, 'POINT', 2)\"" postgres
echo "GIS installation finished"
echo "Database setup finished"