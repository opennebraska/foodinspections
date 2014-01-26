---
category: Firms
path: '/firms/bbox/:bbox'
title: 'Get firms within a bounding box'
type: 'GET'

layout: nil
---

Returns data on all firms in the specified bounding box.

### Request

* **`:bbox`** is the bounding box.

The bounding box should be specified as a strong containing four values separated by commas:

```boxTop,boxLeft,boxBottom,boxRight```

The top and bottom values are the latitudes to search between, and the left and right are the 
longitudes.

### Response

Sends back data on firms in the requested area.

```Status: 200 OK```
```[
  {
    "id": 312,
    "firm_id": 44051,
    "name": "Bar Fly",
    "parent_name": "Stir Entertainment Enterprises Inc.",
    "total_critical": 2,
    "total_noncritical": 4,
    "address": "704 N 114th St\nOmaha, NE",
    "lat": 41.2655,
    "lng": -96.091
  },
  {
    "id": 405,
    "firm_id": 42661,
    "name": "Subway",
    "parent_name": "XCon",
    "total_critical": 2,
    "total_noncritical": 16,
    "address": "630 N 114th St\nOmaha, NE",
    "lat": 41.2649,
    "lng": -96.091
  },
]```

For error responses, see the [response status codes documentation](#response-status-codes).