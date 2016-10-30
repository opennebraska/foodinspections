---
path: '/'
title: 'Introduction'

layout: nil
---

This site documents using the API that powers the 
[Nebraska Food Inspections](http://foodinspections.opennebraska.io) site.

# Use

The API calls below are all given as a relative path. The root for those calls is 
*http://foodinspections.opennebraska.io/api/v1*.

As an example, to use **`/inspections/for/:id`** to look up inspection data for The Woodcliff 
Restaurant in Fremont, NE (which has an ID of 43587) is 
[http://foodinspections.opennebraska.io/api/v1/inspections/for/43587](http://foodinspections.opennebraska.io/api/v1/inspections/for/43587).

# Authentication

No authentication is currently required.

# Social

The live site interacts with third-party APIs for food-related social sites to 
display what people think of individual places in addition to what their inspections 
look like.

To avoid violating Terms of Services and conserve daily API requests, we disallow 
access to these calls.

If you would like to use these APIs, you will need to 
[fork our code](https://github.com/opennebraska/foodinspections/fork) 
and run your own copy. Next, sign up for credentials with the third parties that you 
are interested in using, then add those credentials to 
[config.yml](https://github.com/opennebraska/foodinspections/blob/master/config/config.yml.example).

If you run your own copy of the site and enable these APIs but want remote access (check 
the TOS to ensure you aren't violating them by potentially allowing someone else to use 
their API through you), you can remove 
[a few lines of code](https://github.com/opennebraska/foodinspections/blob/master/api/apibase.rb)
in **ApiBase** to allow systems other than the web server to access them.
