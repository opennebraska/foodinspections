---
category: Inspections
path: '/inspections'
title: 'Get all inspections'
type: 'GET'

layout: nil
---

Returns data on all inspections in the database.

### Response

Sends back a collection of inspections.

```Status: 200 OK```
```[
  {
    "id": 43884,
    "firm_id": 43587,
    "inspection_date": "2012-02-16",
    "inspection_type": 1,
    "business_type": 16,
    "critical_violations": 2,
    "noncritical_violations": 8,
    "followup": false,
    "inspector_number": 9
  },
  {
    "id": 43885,
    "firm_id": 43587,
    "inspection_date": "2011-07-13",
    "inspection_type": 1,
    "business_type": 1,
    "critical_violations": 4,
    "noncritical_violations": 10,
    "followup": false,
    "inspector_number": 9
  }
]```

For error responses, see the [response status codes documentation](#response-status-codes).