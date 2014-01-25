/**
 * @classdesc Class to interact with the inspections API.
 */
function Inspections() {
  /**
   * Gets all points within a given bounding box.
   * 
   * @callback callback
   * @param {number} boxTop - Upper latitude.
   * @param {number} boxLeft - Left longitude.
   * @param {number} boxBottom - Lower latitude.
   * @param {number} boxRight - Right longitude.
   */
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
  
  /**
   * Gets all child properties for a given parent name.
   * 
   * @callback callback
   * @param {string} parentName - The name of the parent.
   */
  this.getChildProperties = function(parentName, callback) {
    this.asyncPropertyListLookupArray('/api/v1/parent/name/' + parentName, callback);
  }
  
  /**
   * Gets all properties whose names are similar to a given string.
   * 
   * @callback callback
   * @param {string} name - The name to search for.
   */
  this.getPropertiesLikeName = function(name, callback) {
    this.asyncPropertyListLookupArray('/api/v1/firms/name/' + name, callback);
  }
  
  /**
   * Asynchronously loads a property by ID.
   * 
   * @callback callback
   * @param {number} firmId - The location/firm ID.
   */
  this.asyncPropertyListLookupJson = function(firmId, callback) {
    this.asyncPropertyListLookup('/api/v1/firms/' + firmId, callback);
  }
  
  /**
   * Loads a property by ID.
   * 
   * @callback callback
   * @param {number} firmId - The location/firm ID.
   */
  this.getPropertyById = function(firmId, callback) {
    $.getJSON('/api/v1/firms/' + firmId, function(data) {
      $.getJSON('/api/v1/inspections/for/' + firmId + '/summary/sorted/desc', function(details) {
        var finalresult = $.extend(data, details, {inspections: details.length});
        callback([finalresult], finalresult.lat, finalresult.lng);
      });
    });
  }
  
  /**
   * Asynchronously looks up a list of properties. The URL passed in is expected to
   * return a JSON object.
   * 
   * @callback callback
   * @param {string} url - The relative URL of the API call to make.
   */
  this.asyncPropertyListLookupJson = function(url, callback) {
    $.getJSON(url, function(data) {
      if (0 < data.length) {
        var list = $.parseJSON(data);
        $.each(list.ids, function(key, val) {
          $.getJSON('/api/v1/firms/' + val, function(result) {
            callback(result);
          });
        });
      } else {
        callback(false);
      }
    });
  }
  
  /**
   * Asynchronously looks up a list of properties. The URL passed in is expected to
   * return an array.
   * 
   * @callback callback
   * @param {string} url - The relative URL of the API call to make.
   */
  this.asyncPropertyListLookupArray = function(url, callback) {
    $.getJSON(url, function(data) {
      if (0 < data.length) {
        $.each(data, function(key, val) {
          callback(val);
        });
      } else {
        callback(false);
      }
    });
  }
}