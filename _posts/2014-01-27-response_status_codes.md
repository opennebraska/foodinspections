---
title: 'Response status codes'

layout: nil
---

### Success

Successes differ from errors in that their body may not be a simple response object with a code and a message. The headers however are consistent across all calls:

* `GET` returns `200 OK` on success

When retrieving stuff for example:

```Status: 200 OK```
```[
  {
    "id": 10526,
    "firm_id": 5,
    "name": "Happy Bar",
    "parent_name": "",
    "total_critical": 0,
    "total_noncritical": 3,
    "address": "601 N 16th\nOmaha, NE",
    "lat": 41.265,
    "lng": -95.9371
  }
]```

### Error

Error responses are simply returning [standard HTTP error codes](http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html) along with some additional information:

* The error code is sent back as a status header,
* The body may include an object describing both the code and message (for debugging and/or display purposes),