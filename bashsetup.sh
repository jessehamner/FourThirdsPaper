#!/bin/bash

# From within GRASS GIS (i.e. once you have set the program 
# up correctly and, among other things have downloaded the
# GTOPO30 file relevant to your part of the world), you 
# must either run this script OR learn enough from
# http://grasswiki.osgeo.org/wiki/GRASS_and_Shell 
# to set up an unattended execution mode.
# You'll set the GRASS_BATCH_JOB environment variable and
# go from there.

# meters in one degree of latitude:
ONEDEGREELATITUDEMETERS=110574

# Thus, roughly, 250m would be 0.0022609 of one degree.
# Similarly, very roughly, 1 km is 0.0083333 of one degree
# (strictly it's more like 0.0090437, but it doesn't evenly
# divide into 1 degree, which is necessary for 360 x 180)
# As a result, the 250m resolution is more like 0.00208333
# of one degree.
# Indeed, if you 
# head -n 6
#
# You can see that's what the SRTM data use:
#
#ncols         72010
#nrows         57610
#xllcorner     -180.01041653225
#yllcorner     -60.01041666665
#cellsize      0.00208333333
#NODATA_value  -9999 

# If you're using SRTM30:



# Example to import GTOPO30 elevation data:

# If you have the GTOPO30 files ready:
MAPNAME="W100N40"
MAPSET="gtopo1"
INPUTDIR=""
 
# r.in.bin -s -b  --o input=W100N40.DEM output=W100N40 title="GTOPO DEM W100N40" bytes=2 cols=4800 anull=-9999 north=40 south=-10 east=-60 west=-100 rows=6000
# r.in.bin -s -b  --o input=${MAPNAME}.DEM output=${MAPNAME} title="GTOPO DEM ${MAPNAME}" bytes=2 cols=4800 anull=-9999 north=40 south=-10 east=-60 west=-100 rows=6000
r.colors map=${MAPNAME} rules=elevation

# Set the region to something relevant to your location:
g.region --o save="GTOPO_earth" n=90 s=-60 w=-180 e=180 res=0.0083333333333 --o

# And import a few city locations:

v.in.ascii input=cities.txt output=cities x=2 y=3 cat=1 columns='cat int, x double precision, y double precision, label varchar(100)' --o --v  

# if you get an error that it is "Unable to open database", you'll need to get straight with
# the db.connect command first. Then re-import the file.
#
# The command would look something like:
# db.connect driver=dbf database=/Volumes/Time\ Machine\ Backups/backup3/grass/

# If you set the resolution to 0.005, you'll get a lot of overlapping values
# from GTOPO, since the 0.011014 value is about one kilometer, and that's about one
# GTOPO30 pixel. Thus, 0.005 will produce a lot of duplicate values, though it will do
# a slightly better job of catching edges between two pixels when you're on a diagonal.

RES="0.005"
# RES="0.011014"

COORD1="-80.8328,35.4911"
COORD2="-82.5558,35.5800"

# Here's the elevation profile:
#r.profile --v input=W100N40@gtopo1 output=profile.txt profile=-80.8328,35.4911,-82.5558,35.5800 res=0.011014

# And with macro substitution:
r.profile --verbose input=${MAPNAME}@${MAPSET} output=profile.txt profile=${COORD1},${COORD2} res=${RES}

# Make the labels file:
echo `head -n 1 profile.txt` " Davidson" > labels.txt
echo "86500.000 390 \"Blue Ridge Distilling Co\" " >> labels.txt
echo `tail -n 1 profile.txt` " Asheville" >> labels.txt

# Obviously your cities might be different!

# To run a few commands through gnuplot:
echo "set terminal png
load 'fourthirdsprofile.gpi'" | gnuplot  > output.png

# the PNG output doesn't matter; it's just to keep binary from 
# spewing on your terminal:
rm output.png 

# LaTeX the file into a PDF:
pdflatex --file-line-error --synctex=1 --shell-escape profilepaper.tex 

# All done.

# EOF
