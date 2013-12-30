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
  		callback([data], data.lat, data.lng, data.count);
		});
	}
	
	
	
	this.asyncPropertyListLookup = function(url, callback) {
		$.getJSON(url, function(data) {
			$('#meter-inside').css('width', '0%');
			$('.meter').slideDown(400);
			var list = $.parseJSON(data);
			var resultCount = list.count;
			var resultCounter = 0;
			if(resultCount == 0) {
				callback(false);
			} else {
				$.each(list.ids, function(key, val) {
					$.getJSON('/api/v1/firms/' + val, function(result) {
						callback(result);
						resultCounter++;
						var resultMath = resultCounter / resultCount;
						resultMath = resultMath * 100;
						document.getElementById("meter-inside").style.width = resultMath + "%";
						if(resultMath == 100) {
							$('.meter').slideUp(300);
						}
					});
				});
			}
		});
	}
}
