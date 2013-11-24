$(document).ready(function() {
var DEFAULTLAT = 41.255817;
var DEFAULTLNG = -95.931284;


$('#loadingdiv').show();
var map = L.map('map');
var plotlayers=[];

function drawMarkers(data) {
	// center_lat, center_lng, radius (meters), callback
	for (var i = 0; i < data.total_rows; i++) {
		var location = data.rows[i];
		var plotmark = new L.marker([location.lat, location.lng]).addTo(map)
		.bindPopup(location.name);
		plotlayers.push(plotmark);
	}
}

function drawMap(lat, lng, zoomLevel) {
    map.setView([lat,lng], zoomLevel);
    var result = getEndPoints();
    //console.log('radius!: ' + result.radius);
    var marker;
    var g = new Geo();
    var layers = new Array();
	g.getPointsInBounds(result.centerLat, result.centerLng, result.radius, drawMarkers);
	
	// add an OpenStreetMap tile layer
	L.tileLayer('http://otile{s}.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
      subdomains: '1234'
    }).addTo(map);
	
	map.on('moveend', function() {
		console.log('hi!');
		removeMarkers();
		var result = getEndPoints();
		g.getPointsInBounds(result.centerLat, result.centerLng, result.radius, drawMarkers);
			
	});
}

if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(successFunction, errorFunction);
}
//Get the latitude and the longitude;
function successFunction(position) {
    var lat = position.coords.latitude;
    var lng = position.coords.longitude;
    drawMap(lat, lng, 13);	
}

function removeMarkers() {
	for (i=0;i<plotlayers.length;i++) {
		map.removeLayer(plotlayers[i]);
	}
	plotlayers=[];
}

function getEndPoints() {
    var center = map.getCenter();
    var centerLat = center.lat;
    var centerLng = center.lng;
    console.log(centerLat);
    console.log(centerLng);
    var bounds = map.getBounds();
    var westLng = bounds.getWest();
    var southLat = bounds.getSouth();
    var eastLng = bounds.getEast();
    var northLat = bounds.getNorth();
    var d = calculateDistance(centerLat, centerLng, eastLng);
    console.log(d);
    var radius = d;
    return {'centerLat': centerLat, 'centerLng': centerLng, 'radius': radius};
}

function toRad(Value) {
    /** Converts numeric degrees to radians */
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
    drawMap(DEFAULTLAT, DEFAULTLNG, 18);
}



    // create a map in the "map" div, set the view to a given place and zoom

$('#loadingdiv').slideUp().hide();

});

