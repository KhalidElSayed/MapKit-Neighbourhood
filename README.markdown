# Neighbourhood Test

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
