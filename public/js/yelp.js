/**
 * @classdesc Class to interact with the Yelp API.
 */
function Yelp() {
  /**
   * Returns search results for the given parameters.
   * 
   * @callback callback
   * @param {string} name - The name to search for.
   * @param {number} latitude - Center point latitude.
   * @param {number} longitude - Center point longitude.
   */
  this.search = function(name, latitude, longitude, callback) {
    $.getJSON('/api/yelp/v1/search/' + latitude + '/' + longitude + '/' + name, function(data) {
      callback(data);
    });
  }
  
  /**
   * Returns search results for the given parameters.
   * 
   * @callback callback
   * @param {string} name - The name to search for.
   * @param {number} latitude - Center point latitude.
   * @param {number} longitude - Center point longitude.
   * @param {number} radius - Radius (in meters) to search.
   */
  this.search = function(name, latitude, longitude, radius, callback) {
    $.getJSON('/api/yelp/v1/search/' + latitude + '/' + longitude + '/' + name + '/' + radius, function(data) {
      callback(data);
    });
  }
}