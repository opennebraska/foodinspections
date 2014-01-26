---
category: Firms
path: '/firms/:name'
title: 'Get all firm by name'
type: 'GET'

layout: nil
---

Returns data on all firms with names similar to the search term.

### Request

* **`:name`** is the name to search for.


### Response

Sends back data on firms in the requested area.

```Status: 200 OK```
```[
  {
    "id": 625,
    "firm_id": 40048,
    "name": "Dleons",
    "parent_name": "",
    "total_critical": 9,
    "total_noncritical": 25,
    "address": "831 N 48th St\nLincoln, NE",
    "lat": 40.8219,
    "lng": -96.6537
  },
  {
    "id": 69,
    "firm_id": 42822,
    "name": "D'Leons Taco Rico",
    "parent_name": "",
    "total_critical": 18,
    "total_noncritical": 40,
    "address": "824 S 27th St\nLincoln, NE",
    "lat": 40.8056,
    "lng": -96.6824
  }
]```

For error responses, see the [response status codes documentation](#response-status-codes).