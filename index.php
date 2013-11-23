<?php
// index.php - Restaurant Inspections
?>

<!DOCTYPE html>
<html>
<head>
<title>
	Restaurant Inspections 
</title>
<style>
html, body, .container { height: 100%; margin: 0;  }
.heading { height: 6%; background-color: #000; color: #ccc; text-align: center;  }
.map { position: relative; height: 94%; width: 100%; }
#map-canvas { height: 100%; }
</style>
<script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=true&libraries=geometry,places"></script>
<script src="//code.jquery.com/jquery-1.10.2.min.js"></script>
<script>
var map;

function getURLParameter(name) {
  return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search)||[,""])[1].replace(/\+/g, '%20'))||null
}

function initialize() {
	var myLatlng = new google.maps.LatLng(41,-99);
	var mapOptions = {
		zoom: 7,
		center: myLatlng
	}

	map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);

	var marker = new google.maps.Marker({
    	position: map.getCenter(),
    	map: map,
    	title: 'Click to zoom'
 	});

	google.maps.event.addListener(map, 'bounds_changed', function() {
		var bounds = map.getBounds();
		var ne = bounds.getNorthEast();
		var sw = bounds.getSouthWest();
		var yMaxLat = ne.lat();
		var xMaxLng = ne.lng();
		var yMinLat = sw.lat();
		var xMinLng = sw.lng();
		console.log(yMaxLat); 
		console.log(xMaxLng);
	});
}

google.maps.event.addDomListener(window, 'load', initialize);
</script>
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
		</div>
	</div>
</body>
</html>