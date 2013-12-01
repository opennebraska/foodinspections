$(document).ready(function() {
	var DEFAULTLAT = 41.255817;
	var DEFAULTLNG = -95.931284;
	var DEFAULTZOOM = 15;
	var NOGEOLOCATION_DEFAULTZOOM = 18;
	var path = window.location.href;
	var cleanPath = path.substr(path.indexOf("=") + 1);
	var pathArray = cleanPath.split( '/' );
	var map = L.map('map');
	var plotlayers=[];
	map.spin(true);
	
	// Did we get an argument that we need to deal with?
	var queryLocation = path.indexOf("?") + 1;
	if (queryLocation > 0) {
	  	var queryString = path.substr(queryLocation);
	  	
	  	// Check to see if they passed in a firm ID
	  	var matchFirm = queryString.match(/firm=(\d+)/);
	  	var cLat = queryString.match(/lat=(\d+)/);
	  	console.log(cLat);
	  	var cLng = queryString.match(/lng=(\d+)/);
	  	console.log(cLng);
	  	cLat = -cLat;
	  	var cRadius = queryString.match(/radius=(\d+)/);
	  	console.log(cRadius);

  		if (matchFirm.length > 0) {
            var db = new Inspections();
            db.getPropertyById(matchFirm[1], drawMapWithPoints);
          } else if (cLat.length > 0 && cLng.length > 0 && cRadius.length > 0) {
	  		drawMap(cLat[1], cLng[1], DEFAULTZOOM);
	  	}
	}
	else {
	  	if (navigator.geolocation) {
	    	navigator.geolocation.getCurrentPosition(successFunction, errorFunction);
	  	}
	}
	
	$('.leaflet-popup-pane').insertBefore('.leaflet-map-pane');
	function drawMarker(data) {
		var ratioToCritical = (data.total_critical / data.total_noncritical);
		var popupRating = "<div class='rating'><div class='mac'><meter value='" + ratioToCritical + "' min='0' max'1'></meter></div></div>";
		var popupLinkTo = "<div class='linkTo'><a href='/?firm=" + data.firm_id + "'>Direct Link to This Result</a></div><div style='clear:both;'></div>";
		var popupInfo = "<div class='info'><span class='name'>" + data.name + "</span><br>Critical Issues: " + data.total_critical + "<br>Non-Critical Issues: " + data.total_noncritical + "</div>"
		var popupText = popupInfo + popupRating + popupLinkTo;
		var plotmark = new L.marker([data.lat, data.lng]).addTo(map).bindPopup(popupText, { autoPan: false, className: 'popup-info', minWidth: "100%", zoomAnimation: false });
		plotlayers.push(plotmark);
		map.spin(false);
	}
	
	function drawMapWithPoints(points, lat, lng, zoomLevel) {
	    zoomLevel = typeof a !== 'undefined' ? zoomLevel : DEFAULTZOOM;
	    map.setView([lat,lng], zoomLevel);
	    
	    var db = new Inspections();
	    var layers = new Array();
	    var result = getEndPoints();
	    var marker;
	    
	  
	  for (var i = 0; i < points.length; i++) {
  	  drawMarker(points[i]);
	  }
		
		// add an OpenStreetMap tile layer
		L.tileLayer('http://otile{s}.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png', {
	      attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
	      subdomains: '1234'
	    }).addTo(map);
		
/*
    // What do we want to do here?
		map.on('moveend', function() {
			removeMarkers();
			
			var result = getEndPoints();
			map.spin(true);
			db.getPointsInBounds(result.centerLat, result.centerLng, result.radius, drawMarker);
		});
*/
	}
	
	function drawMap(lat, lng, zoomLevel) {
	    zoomLevel = typeof a !== 'undefined' ? zoomLevel : DEFAULTZOOM;

	    map.setView([lat,lng], zoomLevel);
	    
	    var db = new Inspections();
	    var layers = new Array();
	    var result = getEndPoints();
	    var marker;
	    
	    
		db.getPointsInBounds(result.centerLat, result.centerLng, result.radius, drawMarker);
		
		// add an OpenStreetMap tile layer
		L.tileLayer('http://otile{s}.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png', {
	      attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
	      subdomains: '1234'
	    }).addTo(map);
		
		map.on('moveend', function() {
			removeMarkers();
			
			var result = getEndPoints();
			map.spin(true);
			db.getPointsInBounds(result.centerLat, result.centerLng, result.radius, drawMarker);
			updateResultLink(result.centerLat, result.centerLng, result.radius);
		});
	
	}
	
	function successFunction(position) {
	    var lat = position.coords.latitude;
	    var lng = position.coords.longitude;
	    
	    drawMap(lat, lng, DEFAULTZOOM);	
	}
	
	function removeMarkers() {
		for (i = 0; i < plotlayers.length; i++) {
			map.removeLayer(plotlayers[i]);
		}
		
		plotlayers = [];
	}

	function updateResultLink(cLat, cLng, cRadius) {
		// this is a function to update the Share This View link
		var shareLink = '?lat=' + cLat + '&lng=' + cLng + '&radius=' + cRadius;
		console.log(shareLink);
		$('.share-link').attr('href', shareLink);
	}
	
	function getEndPoints() {
	    var center = map.getCenter();
	    var centerLat = center.lat;
	    var centerLng = center.lng;
	    var bounds = map.getBounds();
	    var westLng = bounds.getWest();
	    var southLat = bounds.getSouth();
	    var eastLng = bounds.getEast();
	    var northLat = bounds.getNorth();
	    
	    var d = calculateDistance(centerLat, centerLng, eastLng);
	    var radius = d;
	    
	    return {'centerLat': centerLat, 'centerLng': centerLng, 'radius': radius};
	}
	
	function toRad(Value) {
	    return Value * Math.PI / 180;
	}
	
	function calculateDistance(centerLat, centerLng, eastLng) {
		var lat1 = centerLat;
		var lat2 = centerLat;
		var lon1 = centerLng;
		var lon2 = eastLng;
		var R = 6371; // km
		var dLat = toRad(lat2-lat1);
		var dLon = toRad(lon2-lon1);
		var lat1 = toRad(lat1);
		var lat2 = toRad(lat2);
		
		var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
		        Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2); 
		var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
		var d = R * c;
		var d = d * 1000; // convert to M
		
		return d;
	}
	
	function errorFunction(){
	    drawMap(DEFAULTLAT, DEFAULTLNG, NOGEOLOCATION_DEFAULTZOOM);
	}
	
	$('#form').submit(function() {
		searchNames();
		event.preventDefault();
	});
	
	function searchNames() {
		removeMarkers();
		var db = new Inspections();
		var search = $('#search').val();
		
		db.getPropertiesLikeName(search, drawMarker);
	}



});
