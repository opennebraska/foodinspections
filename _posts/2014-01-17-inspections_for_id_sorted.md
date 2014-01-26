---
category: Inspections
path: '/inspections/for/:id/sorted'
title: 'Get a sorted list of inspections for a firm'
type: 'GET'

layout: nil
---

Returns sorted inspections for the requested firm.

### Request

* **`:id`** is the id the firm.

### Response

Sends back inspections for a given firm, sorted by date.

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

