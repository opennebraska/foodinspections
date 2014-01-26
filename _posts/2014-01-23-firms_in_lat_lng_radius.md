---
category: Firms
path: '/firms/in/:lat/:lng/:radius'
title: 'Get firms within a certain area'
type: 'GET'

layout: nil
---

Returns data on all firms in the specified area.

### Request

* **`:lat`** is the center point latitude.
* **`:lng`** is the center point longitude.
* **`:radius`** is the radius from the center point to search.

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