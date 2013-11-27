function Inspections() {
	this.getPointsInBounds = function(centerLat, centerLng, radius, callback) {
		this.asyncPropertyLookup('/api/v1/firms/in/' + centerLat + '/' + centerLng + '/' + radius, callback);
	}
	
	this.getChildProperties = function(parent_name, callback) {
		this.asyncPropertyLookup('/api/v1/parent/by/name/' + parent_name, callback);
	}
	
	this.getPropertiesLikeName = function(name, callback) {
		this.asyncPropertyLookup('/api/v1/firms/by/name/' + name, callback)
	}
	
	
	
	this.asyncPropertyLookup = function(url, callback) {
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
