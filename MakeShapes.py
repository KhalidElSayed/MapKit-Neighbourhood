#!/usr/bin/python

from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String, Binary
from sqlalchemy.orm import sessionmaker

#engine = create_engine('sqlite:///:memory:', echo=False)
engine = create_engine('sqlite:///shapes.sqlite', echo=False)

Base = declarative_base()

class Neighbourhood(Base):
     __tablename__ = 'neighbourhood'

     id = Column(Integer, primary_key=True)
     name = Column(String)
     state = Column(String)
     county = Column(String)
     city = Column(String)
     bbox = Column(String)
     points = Column(Binary)

     def __init__(self, id, name, state, county, city, bbox, points):
         self.id = id
         self.name = name
         self.state = state
         self.county = county
         self.city = city
         self.bbox = bbox
         self.points = points

     def __repr__(self):
        return "Neighbourhood(%d,%s,%s,%s,%s,%s)" % (self.id, self.name, self.state, self.county, self.city, self.bbox)

Base.metadata.create_all(engine)


Session = sessionmaker(bind=engine)
theSession = Session()

################################################################################

import json

import shapefile
theShapeFile = shapefile.Reader('ZillowNeighborhoods-CA/ZillowNeighborhoods-CA')

#print theShapeFile.fields
for theShape, theRecord in zip(theShapeFile.shapes(), theShapeFile.records()):
    theState, theCounty, theCity, theName, theRegionID = (theRecord[0], theRecord[1], theRecord[2], theRecord[3], int(theRecord[4]))
#    print theObject
#    print list(theShape.bbox)
    thePoints = [list(p) for p in theShape.points]
    theObject = Neighbourhood(theRegionID, theName, theState, theCounty, theCity, json.dumps(list(theShape.bbox)), json.dumps(thePoints))
    theSession.add(theObject)

theSession.commit()

################################################################################
