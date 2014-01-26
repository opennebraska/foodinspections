---
category: Inspections
path: '/inspections/:id'
title: 'Get an inspection'
type: 'GET'

layout: nil
---

Returns data on the requested inspection.

### Request

* **`:id`** is the id the inspection.

### Response

Sends back an inspection.

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
  }
]```

For error responses, see the [response status codes documentation](#response-status-codes).