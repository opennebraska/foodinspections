function Inspections() {
	this.getPointsInBounds = function(centerLat, centerLng, radius, callback) {
		this.asyncPropertyListLookup('/api/v1/firms/in/' + centerLat + '/' + centerLng + '/' + radius, callback);
	}
	
	this.getChildProperties = function(parent_name, callback) {
		this.asyncPropertyListLookup('/api/v1/parent/name/' + parent_name, callback);
	}
	
	this.getPropertiesLikeName = function(name, callback) {
		this.asyncPropertyListLookup('/api/v1/firms/name/' + name, callback);
	}

	this.getPropertiesById = function(firmId, callback) {
		this.asyncPropertyListLookup('/api/v1/firms/' + firmId, callback);
	}
	
	this.getPropertyById = function(firmId, callback) {
    $.getJSON('/api/v1/firms/' + firmId, function(data) {
  		callback([data], data.lat, data.lng);
		});
	}
	
	
	
	this.asyncPropertyListLookup = function(url, callback) {
		$.getJSON(url, function(data) {
			var list = $.parseJSON(data);
			
			$.each(list.ids, function(key, val) {
				$.getJSON('/api/v1/firms/' + val, function(result) {
					callback(result);
				});
			});
		});
	}
}
