function Geo() {
	this.apiKey = '648c658c812419eb99b6b30962797a0582131c03';
	this.rootUrl = 'http://rnelson.cartodb.com/api/v2/sql?';
	
	this.getPointsInBounds = function(centerLat, centerLng, radius, callback) {
		var query = "SELECT firm_id, name, lat, lng FROM ne_restaurant_inspections l WHERE ST_Dwithin(l.the_geom::geography, ST_GeogFromText('POINT(" + centerLng + " " + centerLat + ")'), " + radius + ")";
		var url = this.rootUrl + 'q=' + query + '&api_key=' + this.apiKey;
		
		$.get(url, callback);
	}
	
	this.getChildProperties = function(parent_name, callback) {
		var query = "SELECT firm_id, name, lat, lng FROM ne_restaurant_inspections l WHERE l.parent_name='" + escape(parent_name) + "'";
		var url = this.rootUrl + 'q=' + query + '&api_key=' + this.apiKey;
		
		$.get(url, callback);
	}
	
	this.getPropertiesLikeName = function(name, callback) {
		var query = "SELECT firm_id, name, lat, lng FROM ne_restaurant_inspections l WHERE l.name ILIKE '%" + escape(name) + "%'";
		query = encodeURI(query);
		var url = this.rootUrl + 'q=' + query + '&api_key=' + this.apiKey;
		$.get(url, callback);
	}
}

function DGeo() {
	this.apiKey = 'afd2a4ed4bac70d838dcbdf2df0aa86be8f0d75b';
	this.rootUrl = 'http://dlipskey.cartodb.com/api/v2/sql?';
	
	this.getViolationCount = function(firm_id, name, lat, lng, callback) {
		var query = "SELECT firm_id, critical, noncritical FROM violations l WHERE l.firm_id=" + firm_id;
		var url = this.rootUrl + 'q=' + query + '&api_key=' + this.apiKey;
		$.get(url, function(data) {
			var newData = {
				firmId: firm_id,
				placeName: name,
				latitude: lat,
				longitude: lng,
				cartoData: data
			}
			callback(firm_id, newData);
		});
	}
}

function NewGeo() {
	this.doStuff = function(centerLat, centerLng, radius, callback) {
		var query1 = "SELECT firm_id, name, lat, lng FROM ne_restaurant_inspections l WHERE ST_Dwithin(l.the_geom::geography, ST_GeogFromText('POINT(" + centerLng + " " + centerLat + ")'), " + radius + ")";
		
		$.ajax('http://rnelson.cartodb.com/api/v2/sql?q=' + query1 + '&api_key=648c658c812419eb99b6b30962797a0582131c03',
			{
				async: false,
				success: function(rData) {
					newObjects = [];
					
					$.each(rData.rows, function(idx, value) {
						var query2 = "SELECT firm_id, critical, noncritical FROM violations l WHERE l.firm_id=" + value.firm_id;
//						console.log(value);
//						console.log(query2);
						$.ajax('http://dlipskey.cartodb.com/api/v2/sql?q=' + query2 + '&api_key=afd2a4ed4bac70d838dcbdf2df0aa86be8f0d75b',
							{
								async: false,
								success: function(dData) {
//									console.log(dData);
									newObj = {
										firmId: value.firm_id,
										lat: value.lat,
										lng: value.lng,
										name: value.name,
										critical: dData.rows[0].critical,
										noncritical: dData.rows[0].noncritical
									}
									
									newObjects.push(newObj);
								}
							}
						);
					});
					
					callback(newObjects);
				}
			}
		);
	}
	
	this.getPropertiesLikeName = function(name, callback) {
		var query1 = "SELECT firm_id, name, lat, lng FROM ne_restaurant_inspections l WHERE l.name ILIKE '%" + name + "%'";
		
		$.ajax('http://rnelson.cartodb.com/api/v2/sql?q=' + escapedURI(query1) + '&api_key=648c658c812419eb99b6b30962797a0582131c03',
			{
				async: false,
				success: function(rData) {
					newObjects = [];
					
					$.each(rData.rows, function(idx, value) {
						var query2 = "SELECT firm_id, critical, noncritical FROM violations l WHERE l.firm_id=" + value.firm_id;
						$.ajax('http://dlipskey.cartodb.com/api/v2/sql?q=' + query2 + '&api_key=afd2a4ed4bac70d838dcbdf2df0aa86be8f0d75b',
							{
								async: false,
								success: function(dData) {
									newObj = {
										firmId: value.firm_id,
										lat: value.lat,
										lng: value.lng,
										name: value.name,
										critical: dData.rows[0].critical,
										noncritical: dData.rows[0].noncritical
									}
									
									newObjects.push(newObj);
								}
							}
						);
					});
					
					callback(newObjects);
				}
			}
		);
	}

}