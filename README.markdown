# Neighbourhood Test

See https://github.com/TouchCode/MapKit-Neighbourhood/raw/master/Screen%20Shot%202011-12-20%20at%202.59.19%20PM.png

## Neighbourhood Shapefiles

Zillow provides shapefiles describing nearly 7000 neighbourhoods in the largest US cities. This information is licensed under a Creative Commons license. See their page for more information.

http://www.zillow.com/howto/api/neighborhood-boundaries.htm

## Converting shape files

I use python to convert the shape files into a simple sqlite database. You'll need to install sqlalchemy and pyshp

    easy_install sqlalchemy
    easy_install pyshp

Run the "MakeShapes.py" to convert the shape files.

## Loading shape files in MapKit

The shape files (or rather the shape data in the sqlite file) are displayed on a MapKit MKMapView using overlays.

## Other Notes

Don't forget to do a submodule update!

This is just a crude proof of concept. The iOS app is actually less interesting than the rest of the repository. Which shows how to take a .shp file, process it using python and then export it with Python into Objective-C

## Caveats

This is just quick & dirty test code. Do not use in production. Respect the Zillow license!

Memory management. I can see this eating a lot of memory. That should be avoided.

## Ideas

* Make an app that tells you what neighbourhood you're in
* Make an app that uses background CoreLocation APIs to monitor when you enter a bad neighbour
* Something something geo game.
