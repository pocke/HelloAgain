Mongoid Geospatial
==================


A Mongoid Extension that simplifies the use of MongoDB spatial features.

* Version 5.x -> Mongoid 5
* Version 4.x -> Mongoid 4

** Gem name has changed: 'mongoid-geospatial' (notice the hyphen) **
Please change the underscore to a hyphen.
That will require it correctly within bundler:
`require 'mongoid/geospatial'`

[![Gem Version](https://badge.fury.io/rb/mongoid-geospatial.svg)](http://badge.fury.io/rb/mongoid-geospatial)
[![Code Climate](https://codeclimate.com/github/nofxx/mongoid-geospatial.svg)](https://codeclimate.com/github/nofxx/mongoid-geospatial)
[![Coverage Status](https://coveralls.io/repos/nofxx/mongoid-geospatial/badge.svg?branch=master)](https://coveralls.io/r/nofxx/mongoid-geospatial?branch=master)
[![Dependency Status](https://gemnasium.com/nofxx/mongoid-geospatial.svg)](https://gemnasium.com/nofxx/mongoid-geospatial)
[![Build Status](https://travis-ci.org/nofxx/mongoid-geospatial.svg?branch=master)](https://travis-ci.org/nofxx/mongoid-geospatial)


Quick Start
-----------

This gem focus on (making helpers for) MongoDB's spatial features.
But you may also use an external Geometric/Spatial gem alongside.

    # Gemfile
    gem 'mongoid-geospatial'


A `Place` to illustrate `Point`, `Line` and `Polygon`

    class Place
      include Mongoid::Document

      # Include the module
      include Mongoid::Geospatial

      # Just like mongoid,
      field :name,     type: String

      # define your field, but choose a geometry type:
      field :location, type: Point
      field :route,    type: Linestring
      field :area,     type: Polygon

      # To query on your points, don't forget to index:
      # You may use a method:
      sphere_index :location  # 2d
      # or
      spatial_index :location # 2dsphere

      # Or use a helper directly on the `field`:
      field :location, type: Point, spatial: true  # 2d
      # or
      field :location, type: Point, sphere: true   # 2dsphere
    end



Generate indexes on MongoDB via rake:


    rake db:mongoid:create_indexes


Or programatically:


    Place.create_indexes



Points
------

Currently, MongoDB supports query operations on 2D points only, so that's
what this lib does. All geometries apart from points are just arrays
in the database. Here's is how you can input a point as:

* longitude latitude array in that order - [long,lat] ([x, y])
* an unordered hash with latitude key(:lat, :latitude) and a longitude key(:lon, :long, :lng, :longitude)
* an ordered hash with longitude as the first item and latitude as the second item
  This hash does not have include the latitude and longitude keys
  \*only works in ruby 1.9 and up because hashes below ruby 1.9 because they are not ordered
* anything with the a method #to_xy or #to_lng_lat that converts itself to  [long, lat] array

We store data in the DB as a [x, y] array then reformat when it is returned to you


    cafe = Place.create(
      name: 'Café Rider',
      location: {:lat => 44.106667, :lng => -73.935833},
      # or
      location: {latitude: 40.703056, longitude: -74.026667}
      #...

Now to access this spatial information we can do this

    cafe.location  # => [-74.026667, 40.703056]

If you need a hash

    cafe.location.to_hsh   # => { x: -74.026667, y: 40.703056 }

If you are using GeoRuby or RGeo

    cafe.location.to_geo   # => GeoRuby::Point

    cafe.location.to_rgeo  # => RGeo::Point


Conventions:

This lib uses #x and #y everywhere.
It's shorter than lat or lng or another variation that also confuses.
A point is a 2D mathematical notation, longitude/latitude is when you
use that notation to map an sphere. In other words:
All longitudes are 'xs' where not all 'xs' are longitudes.

Distance and other geometrical calculations are delegated to the external
library of your choice. More info about using RGeo or GeoRuby below.
Some built in helpers for mongoid queries:

    # Returns middle point + radius
    # Useful to search #within_circle
    cafe.location.radius(5)        # [[-74.., 40..], 5]
    cafe.location.radius_sphere(5) # [[-74.., 40..], 0.00048..]

    # Returns hash if needed
    cafe.location.to_hsh              # {:x => -74.., :y => 40..}
    cafe.location.to_hsh(:lon, :lat)  # {:lon => -74.., :lat => 40..}


And for polygons and lines:

    house.area.bbox    # Returns polygon bounding_box (envelope)
    house.area.center  # Returns calculate middle point





Model Setup
-----------

You can create Point, Line, Circle, Box and Polygon on your models:


    class CrazyGeom
      include Mongoid::Document
      include Mongoid::Geospatial

      field :location,  type: Point, spatial: true, delegate: true

      field :route,     type: Line
      field :area,      type: Polygon

      field :square,    type: Box
      field :around,    type: Circle

      # default mongodb options
      spatial_index :location, {bit: 24, min: -180, max: 180}

      # query by location
      spatial_scope :location
    end


Helpers
-------

You can use `spatial: true` to add a '2d' index automatically,
No need for `spatial_index :location`:


    field :location,  type: Point, spatial: true


And you can use `sphere: true` to add a '2dsphere' index automatically,
No need for `spatial_sphere :location`:


    field :location,  type: Point, sphere: true


You can delegate some point methods to the instance itself:


    field :location,  type: Point, delegate: true


Now instead of `instance.location.x` you may call `instance.x`.


Nearby
------

You can add a `spatial_scope` on your models. So you can query:

    Bar.nearby(my.location)

instead of

    Bar.near(location: my.location)

Good when you're drunk. Just add to your model:

    spatial_scope :<field>



Geometry
--------

You can also store Circle, Box, Line (LineString) and Polygons.
Some helper methods are available to them:


    # Returns a geometry bounding box
    # Useful to query #within_geometry
    polygon.bbox
    polygon.bounding_box

    # Returns a geometry calculated middle point
    # Useful to query for #near
    polygon.center

    # Returns middle point + radius
    # Useful to search #within_circle
    polygon.radius(5)        # [[1.0, 1.0], 5]
    polygon.radius_sphere(5) # [[1.0, 1.0], 0.00048..]


Query
-----

Before you read about this gem have sure you read this:

http://mongoid.org/en/origin/docs/selection.html#standard

All MongoDB queries are handled by Mongoid/Origin.

http://www.rubydoc.info/github/mongoid/origin/Origin/Selectable

You can use Geometry instance directly on any query:

* near


```
Bar.near(location: person.house)
Bar.where(:location.near => person.house)
```

* near_sphere

```
Bar.near_sphere(location: person.house)
Bar.where(:location.near_sphere => person.house)
```

* within_polygon

```
Bar.within_polygon(location: [[[x,y],...[x,y]]])
# or with a bbox
Bar.within_polygon(location: street.bbox)
```


* intersects_line
* intersects_point
* intersects_polygon



External Libraries
------------------

We currently support GeoRuby and RGeo.
If you require one of those, a #to_geo and #to_rgeo, respectivelly,
method(s) will be available to all spatial fields, returning the
external library corresponding object.


### Use RGeo?
https://github.com/dazuma/rgeo

RGeo is a Ruby wrapper for Proj/GEOS.
It's perfect when you need to work with complex calculations and projections.
It'll require more stuff installed to compile/work.


### Use GeoRuby?
https://github.com/nofxx/georuby

GeoRuby is a pure Ruby Geometry Library.
It's perfect if you want simple calculations and/or keep your stack in pure ruby.
Albeit not full featured in maths it has a handful of methods and good import/export helpers.


### Example

    class Person
      include Mongoid::Document
      include Mongoid::Geospatial

      field :location, type: Point
    end

    me = Person.new(location: [8, 8])

    # Example with GeoRuby
    point.class # Mongoid::Geospatial::Point
    point.to_geo.class # GeoRuby::SimpleFeatures::Point

    # Example with RGeo
    point.class # Mongoid::Geospatial::Point
    point.to_rgeo.class # RGeo::Geographic::SphericalPointImpl


## Configure

Assemble it as you need (use a initializer file):

With RGeo

    Mongoid::Geospatial.with_rgeo!
    # Optional
    # Mongoid::Geospatial.factory = RGeo::Geographic.spherical_factory


With GeoRuby

    Mongoid::Geospatial.with_georuby!


Defaults (change if you know what you're doing)

    Mongoid::Geospatial.lng_symbol = :x
    Mongoid::Geospatial.lat_symbol = :y
    Mongoid::Geospatial.earth_radius = EARTH_RADIUS



This Fork
---------

This fork is not backwards compatible with 'mongoid_spacial'.
This fork delegates calculations to external libs.

Change in your models:

    include Mongoid::Spacial::Document

to

    include Mongoid::Geospatial


And for the fields:


    field :source,  type: Array,    spacial: true

to

    field :source,  type: Point,    spatial: true # or sphere: true


Beware the 't' and 'c' issue. It's spaTial.



Troubleshooting
---------------

**Mongo::OperationFailure: can't find special index: 2d**

Indexes need to be created. Execute command:

    rake db:mongoid:create_indexes

Programatically

    Model.create_indexes


Contributing
------------

* Have mongod running
* Install dev gems with `bundle install`
* Run `rake spec`, `spec spec` or `guard`
