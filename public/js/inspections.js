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
    this.asyncPropertyListLookupArray('/api/v1/parent/name/' + parent_name, callback);
  }
  
  this.getPropertiesLikeName = function(name, callback) {
    this.asyncPropertyListLookupArray('/api/v1/firms/name/' + name, callback);
  }

  this.asyncPropertyListLookupJson = function(firmId, callback) {
    this.asyncPropertyListLookup('/api/v1/firms/' + firmId, callback);
  }
  
  this.getPropertyById = function(firmId, callback) {
    $.getJSON('/api/v1/firms/' + firmId, function(data) {
      $.getJSON('/api/v1/inspections/for/' + firmId + '/summary/sorted/desc', function(details) {
        var finalresult = $.extend(data, details, {inspections: details.length});
        callback([finalresult], finalresult.lat, finalresult.lng);
      });
    });
  }
  
  this.asyncPropertyListLookupJson = function(url, callback) {
    $.getJSON(url, function(data) {
      if (0 < data.length) {
        console.log(data);
        var list = $.parseJSON(data);
        $.each(list.ids, function(key, val) {
          $.getJSON('/api/v1/firms/' + val, function(result) {
            callback(result);
            console.log(result);
          });
        });
      } else {
        callback(false);
      }
    });
  }
  
  this.asyncPropertyListLookupArray = function(url, callback) {
    $.getJSON(url, function(data) {
      if (0 < data.length) {
        $.each(data, function(key, val) {
/*
          console.log('==== inspections.js:51: asyncPropertyListLookupArray(url, callback)');
          console.log('----------  key ----------');
          console.log(key);
          console.log('---------- /key ----------');
          console.log('----------  val ----------');
          console.log(val);
          console.log('---------- /val ----------');
          console.log('-------  data[key] -------');
          console.log(data[key]);
          console.log('------- /data[key] -------');
*/
          callback(val);
        });
/*
        for (var idx in data) {
          console.log('==== inspections.js:51: asyncPropertyListLookupArray(url, callback)');
          console.log('-------  data[idx] -------');
          console.log(data[idx]);
          console.log('------- /data[idx] -------');
          
          callback(data[idx]);
*/
/*
          $.getJSON('/api/v1/firms/' + data[idx]['firm_id'], function(result) {
            console.log(result); //!kill
            callback(result);
          });
*/
//        }
      } else {
        callback(false);
      }
    });
  }

}
