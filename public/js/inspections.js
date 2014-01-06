function Inspections() {
	this.getPointsInBoundingBox = function(boxTop, boxLeft, boxBottom, boxRight, callback) {
		var bbox = [boxTop, boxLeft, boxBottom, boxRight].join(',');
		$.getJSON('/api/v1/firms/bbox/' + bbox, function(data) {
			if(data.length > 0) {
				callback(data);
			} else {
				callback(false);
			}
		});
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
	  		$.getJSON('/api/v1/inspections/for/' + firmId + '/summary', function(details) {
	  			var finalresult = $.extend(data, details, {inspections: details.length});
	  			callback([finalresult], finalresult.lat, finalresult.lng);
	  		});
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
