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
}
