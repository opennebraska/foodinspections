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
<script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=true&libraries=geometry,places"></script>
<script src="//code.jquery.com/jquery-1.10.2.min.js"></script>
<script src="js/script.js"></script>
</head>

<body>
	<div class="container">
		<div class="heading">
			<div class="heading-header">
				Restaurant Inspections
			</div>
			<div class="heading-text">
			</div>
			<div class="search-box">
				<form>
				<input type="text" id="search" name="search" placeholder="Find a restaurant" />
				<input type="submit" onClick="javascript:initialize();" />
				</form>
			</div>
		</div>
		<div class="map">
			<div id="map-canvas"></div>
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