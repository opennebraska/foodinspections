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