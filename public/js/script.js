$(document).ready(function() {
  var DEFAULTLAT = 41.255817;
  var DEFAULTLNG = -95.931284;
  var DEFAULTZOOM = 15;
  var NOGEOLOCATION_DEFAULTZOOM = 18;
  var path = window.location.href;
  var cleanPath = path.substr(path.indexOf('=') + 1);
  var pathArray = cleanPath.split('/');
  var map = L.map('map');
  var plotlayers=[];
  var numberOfResults = 0;
  map.spin(true);
  
  var urlBits = parseUrl();
  if (undefined != urlBits['firm']) {
    var db = new Inspections();
    db.getPropertyById(urlBits['firm'], drawMapWithPoints);
  }
  else if (undefined != urlBits['view']) {
    drawMap(urlBits['view']['lat'], urlBits['view']['lng'], DEFAULTZOOM);
  }
  else if (undefined != urlBits['parent']) {
    var db = new Inspections();
    db.getChildProperties(urlBits['parent'], function(result) {
      drawMapWithNoPoints(result.lat, result.lng, 10);
      drawMarker(result);
    });
  }
  else {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(successFunction, errorFunction);
    }
  }
  
  $('.leaflet-popup-pane').insertBefore('.leaflet-map-pane');

  function drawMarkers(markers) {
    $.each(markers, function(idx, val) {
      drawMarker(val);
    });
  }

  function drawMarker(data) {
    var Icon = configureIcon(data.total_critical, data.total_noncritical);
    var popupLinkTo = "<br><div class='linkTo'><a href='/?firm=" + data.firm_id + "'>Inspection Details</a></div>";
    if (data.parent_name.length > 0) {
      var popupParent = "<br><div class='parent'>Find all establishments owned by <br><a href='/?parent=" + data.parent_name + "'>" + data.parent_name + "</a></div><div style='clear:both;'></div>";
    } else {
      var popupParent = "<br><div class='parent'>This establishment has no parent company information.</div><div style='clear:both;'></div>";
    }

    var inspectionData = new String();
    var isFirmPage = false;
    
    for(var i = 0; i < data.inspections; i++) {
      inspectionData += '<br><div><b>' + data[i].date + '</b><br><span>Critical Violations: ' + data[i].total_critical + '</span><br><span>Non-Critical Violations: ' + data[i].total_noncritical + '</span></div>';
      isFirmPage = true;
    }
    
    var popupInfo = "<div class='info'><span class='name'>" + data.name + "</span><br>" + data.address + "<br><br><b>Issue Summary</b><br>Critical Issues: " + data.total_critical + "<br>Non-Critical Issues: " + data.total_noncritical + "</div>";
    
    if (isFirmPage == true) {
      var dataNameClean = data.name.replace("'", "");
      var popupShareTo = "<div class='shareTo'><a target='_blank' class='fb-link' href='http://www.facebook.com/sharer.php?s=100&p[url]=http%3A%2F%2Ffoodinspections.opennebraska.io%2F%3Ffirm%3D" + data.firm_id + "&p[title]=Food%20Inspection%20of%20" + encodeURIComponent(data.name) + "&p[summary]=A%20quick%20glance%20at%20the%20number%20of%20critical%20and%20non-critical%20violations%20establishments%20have%20had%20in%20the%20last%203%20years%20in%20Nebraska.%20Still%20a%20work%20in%20progress%2C%20and%20not%20meant%20to%20scare.&p[images][0]=http%3A%2F%2Fopenclipart.org%2Fimage%2F800px%2Fsvg_to_png%2F33385%2Fpizza_4_stagioni_archite_01.png'><img src='http://i.stack.imgur.com/L8rHf.png' alt='Share on Facebook' /></a><a class='twitter-link' href='https://twitter.com/intent/tweet?text=Food%20Inspection%20for%20" + encodeURIComponent(dataNameClean) + "&url=http%3A%2F%2Ffoodinspections.opennebraska.io%2F%3Ffirm%3D" + data.firm_id + "&via=nefoodinspect' target='_blank'><img src='https://dev.twitter.com/sites/default/files/images_documentation/bird_blue_16_1.png' alt='Tweet This' /></a></div>";
      var popupText = popupInfo + popupParent + popupShareTo + '<div class="inspectionsData">' + inspectionData + '</div>';
    } else {
      var popupText = popupInfo + popupLinkTo + popupParent; 
    }
    
    var plotmark = L.marker([data.lat, data.lng], {icon: Icon}).addTo(map).bindPopup(popupText, { autoPan: false, className: 'popup-info', minWidth: "100%", zoomAnimation: false });
    plotlayers.push(plotmark);
    numberOfResults++;
    map.spin(false);
  }

  function drawMapWithPoints(points, lat, lng, count, zoomLevel) {
    zoomLevel = typeof a !== 'undefined' ? zoomLevel : DEFAULTZOOM;
    map.setView([lat,lng], zoomLevel);
    
    var db = new Inspections();
    var layers = new Array();
    var result = getEndPoints();
    var marker;
    
    updateResultLink(lat, lng, zoomLevel);
    for (var i = 0; i < points.length; i++) {
      drawMarker(points[i]);
    }
    
    // add an OpenStreetMap tile layer
    L.tileLayer('http://otile{s}.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
        subdomains: '1234',
        detectRetina: true,
        reuseTiles: true
      }).addTo(map);

    map.on('popupopen', function() {
      $('.popup-info').attr('style', '');
    });

      if (numberOfResults == 1) {
      plotlayers[0].openPopup();
    
    }
  } 
  
  function drawMap(lat, lng, zoomLevel) {
    zoomLevel = typeof a !== 'undefined' ? zoomLevel : DEFAULTZOOM;

    map.setView([lat,lng], zoomLevel);
    
    var db = new Inspections();
    var layers = new Array();
    var bounds = map.getBounds();
    var marker;
    updateResultLink(lat, lng, zoomLevel);
      
    db.getPointsInBoundingBox(bounds.getNorth(), bounds.getWest(), bounds.getSouth(), bounds.getEast(), function(data){
      if(data.length > 0) {
        drawMarkers(data);
      } else {
        drawMap(DEFAULTLAT, DEFAULTLNG, NOGEOLOCATION_DEFAULTZOOM);
        $('.notice').html('We redirected you to our default location (Omaha, Nebraska) due to no points within 6 miles of your location.').fadeIn().delay(10000).fadeOut();
      }
    });
    
    // add an OpenStreetMap tile layer
    L.tileLayer('http://otile{s}.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
        subdomains: '1234',
        detectRetina: true,
        reuseTiles: true
      }).addTo(map);
    
    map.on('moveend', function() {
      removeMarkers();
      var bounds = map.getBounds();
      var result = getEndPoints();
      
      map.spin(true);
      db.getPointsInBoundingBox(bounds.getNorth(), bounds.getWest(), bounds.getSouth(), bounds.getEast(), function(data){
        if(data.length > 0) {
          drawMarkers(data);
        } else {
          $('.notice').html('There are no points within this map view. Please zoom out or move the map.').fadeIn();
          map.spin(false);
        }
      });
      updateResultLink(result.centerLat, result.centerLng, result.radius);
      
      numberOfResults = 0;
      $('.popup-info').attr('style', '');
    });

    map.on('popupopen', function() {
      $('.popup-info').attr('style', '');
    });

    map.on('click', function() {
      $('.popup-info').attr('style', '');
    });
  }

  function drawMapWithNoPoints(lat, lng, zoomLevel) {
    //zoomLevel = typeof a !== 'undefined' ? zoomLevel : DEFAULTZOOM;
    map.setView([lat,lng], zoomLevel);

    // add an OpenStreetMap tile layer
    L.tileLayer('http://otile{s}.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
        subdomains: '1234',
        detectRetina: true,
        reuseTiles: true
      }).addTo(map);

    map.on('popupopen', function() {
      $('.popup-info').attr('style', '');
    });
  }
  
  function successFunction(position) {
    var lat = position.coords.latitude;
    var lng = position.coords.longitude;

    drawMap(lat, lng, DEFAULTZOOM);
    map.spin(false);
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
    
    db.getPropertiesLikeName(search, function(data) {
      if(data == false) {
        queryGoogle(search);
      } else {
        console.log(data);
        drawMapWithNoPoints(41, 99, 5);
        map.setZoom(3);
        // for (var i = 0; i < data.length; i++) {
        //   drawMarker(data[i]);
        // }
      }
    });
  }

  function queryGoogle(search) {
    var url = "http://maps.google.com/maps/api/geocode/json?address=";
    var search = search.replace(',', '+');
    var search = search.replace(' ', '+');
    var sensor = "&sensor=false";
    url = url + search + sensor;
    
    $.getJSON(url, function(googleData) {
      var lat = googleData.results[0].geometry.location.lat;
      var lng = googleData.results[0].geometry.location.lng;
      map.panTo(new L.LatLng(lat, lng));
    });
  }

  function configureIcon(critical, noncritical) {
    if (critical > 15) {
      var Icon = L.icon({
          iconUrl: '../img/red.svg',
          iconSize: [50, 50],
          iconAnchor: [25, 44]
      });
    }
    else if (critical == 0 && noncritical < 5) {
      var Icon = L.icon({
          iconUrl: '../img/green.svg',
          iconSize: [50, 50],
          iconAnchor: [25, 44]
      });
    }
    else {
      var Icon = L.icon({
          iconUrl: '../img/yellow.svg',
          iconSize: [50, 50],
          iconAnchor: [25, 44]
      });
    }
    
    return Icon;
  }
  
  function parseUrl() {
    var ret = {};
    var haveQuery = false;
    
    // Grab the entire URL they visited
    var url = window.location.href;
    if (undefined != url) {
      ret['url'] = url;
    }
    
    // Check for a query string
    var queryLocation = url.indexOf("?") + 1;
    if (queryLocation > 0) {
      var queryString = url.substr(queryLocation);
      if (undefined != queryString) {
        ret['query'] = queryString;
        haveQuery = true;
      }
    }
    
    // If we have a query string, grab the individual parts
    if (haveQuery) {
      // Firm ID?
      var matchFirm = queryString.match(/firm=(\d+)/);
      if (null != matchFirm && matchFirm.length > 0) {
        ret['firm'] = matchFirm[1];
      }
      
      // Specific view?
      var matchLat = queryString.match(/lat=(-?\d+.?\d+)/);
      var matchLng = queryString.match(/lng=(-?\d+.?\d+)/);
      var matchRadius = queryString.match(/radius=(\d+.?\d+)/);
      if (null != matchLat && null != matchLng && null != matchRadius) {
        ret['view'] = {};
        ret['view']['lat'] = matchLat[1];
        ret['view']['lng'] = matchLng[1];
        ret['view']['radius'] = matchRadius[1];
      }

      // Parent name?
      var parentName = queryString.match(/parent\=(.*$)/);
      if (null != parentName) {
        parentName[1] = parentName[1].replace(/%20/g, ' ');
        ret['parent'] = parentName[1];
      }
    }
    
    return ret;
  }
  
  if (matchMedia('only screen and (min-width: 640px)').matches) {
    $('.heading-header').mouseover(function() {
      $('.home').fadeIn(50);
    });
    
    $('.heading-header').mouseout(function() {
      $('.home').fadeOut(50);
    });
  }

  $('.heading-header-links a.link-about').click(function () {
    $('#how, #soon').hide();
    $('.popup-window').slideDown(300);
    $('#about').fadeIn(100);
  });
  
  $('.heading-header-links a.link-how').click(function () {
    $('#about, #soon').hide();
    $('.popup-window').slideDown(300);
    $('#how').fadeIn(100);
  });
  
  $('.heading-header-links a.link-soon').click(function () {
    $('#about, #how').hide();
    $('.popup-window').slideDown(300);
    $('#soon').fadeIn(100);
  });
  
  $('.popup-window a.link-close, #map').click(function () {
    $('.popup-window').slideUp(300);
  });
});
