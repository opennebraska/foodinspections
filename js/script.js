$(document).ready(function() {
var lat;
var lng;
var map = L.map('map');

if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(successFunction, errorFunction);
} 
//Get the latitude and the longitude;
function successFunction(position) {
    lat = position.coords.latitude;
    lng = position.coords.longitude;
    map.setView([lat,lng], 13);
    var center = map.getCenter();
    var centerLat = center.lat;
    console.log(centerLat);
}

function errorFunction(){
    alert("Geocoder failed");
}


    // create a map in the "map" div, set the view to a given place and zoom

// add an OpenStreetMap tile layer
L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
}).addTo(map);

});

