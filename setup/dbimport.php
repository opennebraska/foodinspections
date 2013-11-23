<?php

// # aptitude install postgresql-9.1-postgis
// # su - postgres
// $ psql
// postgres=# create user ho3 with password 'password';
// postgres=# create database inspections;
// postgres=# grant all privileges on database inspections to ho3;
// postgres=# \q
// $ psql --username=postgres --dbname=inspections --file=/usr/share/postgresql/9.1/contrib/postgis-1.5/postgis.sql
// $ psql --username=postgres --dbname=inspections --file=/usr/share/postgresql/9.1/contrib/postgis-1.5/spatial_ref_sys.sql
// $ psql -d inspections
// postgres=# GRANT Truncate, Insert, Select, Delete, Trigger, References, Update ON TABLE "public"."spatial_ref_sys" TO "ho3";
// postgres=# GRANT Truncate, Insert, Select, Delete, References, Trigger, Update ON TABLE "public"."geometry_columns" TO "ho3";
// $ exit

define(IMPORTFILE, 'State_restaurant_inspections.csv');

if (($fp = fopen(IMPORTFILE, 'r')) !== FALSE) {
	$row = 0;
	
	// Connec to the database
	$db = pg_connect('host=15.126.244.50 dbname=inspections user=ho3 password="Cwth8AR+E8J84WYKQo"')
		or die('error: cannot connect to database');
		
	// Drop (if needed) and create our table
	pg_query($db, 'drop table if exists data');
	pg_query($db, 'create table data (id serial primary key, name varchar(255), parent_name varchar(255), inspection_date date, inspection_type integer, business_type integer, critical_violations integer, noncritical_violations integer, followup boolean, inspector_number integer, street varchar(255), city varchar(255), state char(2));');
	pg_query($db, 'select AddGeometryColumn("public", "data", "coord", 4326, "POINT", 2);');
	
	// Create a prepared statement for the insert query
	pg_prepare($db, 'insertstmt', 'insert into data(name, parent_name, inspection_date, inspection_type, business_type, critical_violations, noncritical_violations, followup, inspector_number, street, city, street) values($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)');
	pg_prepare($db, 'coordstmt', 'insert into data(coord) values(ST_SetSRID(ST_MakePoint($1, $2), 4326)');
	
	while (($csv = fgetcsv($fp)) !== FALSE) {
		// Skip the header row
		if ($row == 0) {
			$row++;
			continue;
		}
		
		// Pull everything out of the array
		$id = $csv[0];
		$name = $csv[1];
		$corporationName = $csv[2];
		$city = $csv[3];
		$date = date_parse($csv[4]);
		$inspectionType = $csv[5];
		$businessType = $csv[6];
		$criticalViolations = $csv[7];
		$noncriticalViolations = $csv[8];
		$followUp = $csv[9];
		$inspectorNumber = $csv[10];
		
		// Separate address, latitude, and longitude
		list($address, $geoCoords) = explode('(', $csv[11]);
		list($geoCoords, $junk) = explode(')', $geoCoords);
		list($lat, $long) = explode(',', $geoCoords);
		$lat = trim($lat);
		$long = trim($long);
		
		// Separate parts of the address
		list($street, $cityState) = explode("\n", $address);
		list($city, $state) = explode(',', $cityState);
		$city = trim($city);
		$state = ltrim($state);
		
		// Reformat the date
		$year = $date['year'];
		$month = (intval($date['month']) < 10 ? '0' : '') . $date['month'];
		$day = $date['day'];
		$date = $year . '-' . $month . '-' . $day;
		
		// Add it to the database
		$mainData = array(
			$name,
			$corporationName,
			$date,
			$inspectionType,
			$businessType,
			$criticalViolations,
			$noncriticalViolations,
			$followUp,
			$inspectorNumber,
			$street,
			$city,
			$state
		);
		$coordData = array($lat, $long);
		$result = pg_execute($db, 'insertstmt', $mainData);
		print_r($result); echo "<br>";
		pg_execute($db, 'coordstmt', $coordData);
		echo $result; echo "<br><br><br>";

/*
		echo "<pre>";
		echo "ID:            " . $id . "<br>";
		echo "Name:          " . $name . "<br>";
		echo "Parent:        " . $corporationName . "<br>";
		echo "City:          " . $city . "<br>";
		echo "Date:          " . $date . "<br>";
		echo "Inspection:    " . $inspectionType . "<br>";
		echo "Business Type: " . $businessType . "<br>";
		echo "Crit Vio:      " . $criticalViolations . "<br>";
		echo "Noncrit Vio:   " . $noncriticalViolations . "<br>";
		echo "Follow Up:     " . $followUp . "<br>";
		echo "Inspector:     " . $inspectorNumber . "<br>";
		echo "Address:       " . $street . "<br>";
		echo "City:          " . $city . "<br>";
		echo "State:         " . $state . "<br>";
		echo "Latitude:      " . $lat . "<br>";
		echo "Longitude:     " . $long . "<br>";
		echo "<br>";
		echo "</pre>";
*/
		
		$row++;
	}
	
	fclose($fp);
	
	echo "Import complete.";
}
else {
	echo "Error opening file";
}
