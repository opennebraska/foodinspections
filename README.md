## Food Inspections API

One of our early design goals for the Food Inspections project was to provide an API. Most of this API 
is accessible to the public, allowing anyone to build something else awesome using the data we have.

### Using the API

The API is a simple REST interface. [View the documentation](http://opennebraska.github.io/ne_state_restaurant_inspections/) 
for more information.

At present we don't require any form of authentication. This is subject to change.

### Restrictons

We have restricted access to any API calls that rely on third-party services. This was done because 
those APIs generally have a limit on the number of calls you can make per day (which would be much 
easier to hit if it wasn't just [our site](http://foodinspections.opennebraska.io) calling them) and 
because it's often against the Terms of Service to make their APIs available to others.

If you wish to use them, you can [fork our code](https://github.com/opennebraska/ne_state_restaurant_inspections/fork) 
and run a copy yourself. You'll need to register with those third parties, agreeing to their terms 
of services and obtaining credentials to fill in 
[config.yml](https://github.com/opennebraska/ne_state_restaurant_inspections/blob/master/config/config.yml.example).
