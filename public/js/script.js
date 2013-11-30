$(document).ready(function() {
	var DEFAULTLAT = 41.255817;
	var DEFAULTLNG = -95.931284;
	var DEFAULTZOOM = 15;
	var NOGEOLOCATION_DEFAULTZOOM = 18;
	var path = window.location.href;
	var cleanPath = path.substr(path.indexOf("=") + 1);
	var pathArray = cleanPath.split( '/' );
	
	// Did we get an argument that we need to deal with?
	var queryLocation = path.indexOf("?") + 1;
	if (queryLocation > 0) {
  	var queryString = path.substr(queryLocation);
  	
  	// Check to see if they passed in a firm ID
  	var matchFirm = queryString.match(/firm=(\d+)/);
  	if (matchFirm.length > 0) {
    	var db = new Inspections();
    	db.getPropertiesById(matchFirm[1], drawMap);
  	}
	}
	else {
  	if (navigator.geolocation) {
    	navigator.geolocation.getCurrentPosition(successFunction, errorFunction);
  	}
	}

/*
	if(window.location.pathname.length > 0) {
		if(pathArray[0] == "api" && pathArray[1] == "v1" && pathArray[2] == "firms" && pathArray[3] == "in") {
			DEFAULTLAT = pathArray[4];
			DEFAULTLNG = pathArray[5];
			DEFAULTZOOM = 18;
			drawMap(DEFAULTLAT, DEFAULTLNG, NOGEOLOCATION_DEFAULTZOOM);
		} else if (pathArray[0] == "api" && pathArray[1] == "v1" && pathArray[2] == "firms" && pathArray[3] == "id") {
			var db = new Inspections();
			db.getPropertiesById(pathArray[4], drawMap);
		} else { 
			if (navigator.geolocation) {
	   			navigator.geolocation.getCurrentPosition(successFunction, errorFunction);
		 }
		}
	}
*/
	
	//$('#loadingdiv').show();
	var map = L.map('map');
	var plotlayers=[];
	map.spin(true);
	$('.leaflet-popup-pane').insertBefore('.leaflet-map-pane');
	function drawMarker(data) {
		var ratioToCritical = (data.total_critical / data.total_noncritical);
		var popupRating = "<div class='rating'>Rating (based upon ratio of critical to non-critical)" + ratioToCritical + "</div><div style='clear:both;'></div>";
		var popupLinkTo = "<div class='linkTo'><a href='http://foodinspections.opennebraska.io/api/v1/firms/" + data.firm_id + "'>Share This Result</a></div>";
		var popupInfo = "<div class='info'><span class='name'>" + data.name + "</span><br>Critical Issues: " + data.total_critical + "<br>Non-Critical Issues: " + data.total_noncritical + "</div>"
		var popupText = popupInfo + popupRating + popupLinkTo;
		var plotmark = new L.marker([data.lat, data.lng]).addTo(map).bindPopup(popupText, { autoPan: false, className: 'popup-info', minWidth: "100%", zoomAnimation: false });
		plotlayers.push(plotmark);
		map.spin(false);
	}
	
	function drawMap(lat, lng, zoomLevel) {
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
