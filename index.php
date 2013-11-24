<?php
// index.php - Restaurant Inspections
?>

<!DOCTYPE html>
<html>
<head>
<title>
	Restaurant Inspections 
</title>
<link rel="stylesheet" href="css/design.css" type="text/css" />
<link rel="stylesheet" href="http://cdn.leafletjs.com/leaflet-0.6.4/leaflet.css" />
<script src="http://cdn.leafletjs.com/leaflet-0.6.4/leaflet.js"></script>
<script src="//code.jquery.com/jquery-1.10.2.min.js"></script>
<script src="js/geo.js"></script>
<script src="js/script.js"></script>
</head>

<body>
	<div class="container">
	<div id="loadingdiv"></div>
		<div class="heading">
			<div class="heading-header">
				Restaurant Inspections
			</div>
			<div class="heading-text">
			</div>
			<div class="search-box">
				<form>
				<input type="text" id="search" name="search" placeholder="Find a restaurant" />
				<input type="submit" />
				</form>
			</div>
		</div>
		<div class="map">
			<div id="map"></div>
		</div>
		<div class="point-info">
			<div class="restaurant-name">
				
			</div>
			<div class="restaurant-address">
			
			</div>
			<div class="restaurant-critical">
			
			</div>
			<div class="restaurant-noncritical">
			
			</div>
			<div class="restaurant-parent">
			
			</div>
		</div>
	</div>
</body>
</html>