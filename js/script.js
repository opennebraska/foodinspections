$(document).ready(function() {
$('#loadingdiv').show();
var map = L.map('map');

if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(successFunction, errorFunction);
} 
//Get the latitude and the longitude;
function successFunction(position) {
    var lat = position.coords.latitude;
    var lng = position.coords.longitude;
    map.setView([lat,lng], 13);
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
    // getPoints(northLat, westLng, southLat, eastLng, mapPoints());
    var d = calculateDistance(centerLat, centerLng, eastLng);
    console.log(d);
    var radius = d;
    
    var cartoClient = new Geo();
    cartoClient.getPointsInBounds(centerLat, centerLng, radius, function(data) {
	    // do something with json array 'data'
	    
    });
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
    alert("Geocoder failed");
}


    // create a map in the "map" div, set the view to a given place and zoom

// add an OpenStreetMap tile layer
L.tileLayer('http://otile{s}.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
      subdomains: '1234'
    }).addTo(map);
$('#loadingdiv').slideUp().hide();

});

