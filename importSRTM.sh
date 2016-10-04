#!/bin/bash

MAPNAME="STRM_41_W_250"
MAPSET="SRTMW"
INPUTDIR=""

# WARNING: this file is 22 GB uncompressed.

FILENAME="srtm_w_250m.asc"
 
# Set the region to something relevant to your location:
g.region --o save="SRTM_WEST" n=60 s=-60 w=-180 e=-29.9 res=0.002083333333 --o

#ncols         72010
#nrows         57610
#xllcorner     -180.01041653225
#yllcorner     -60.01041666665
#cellsize      0.00208333333
#NODATA_value  -9999

# WARNING: this file will make your computer cry. Hard.
r.in.asc --o --v input=${FILENAME} output=${MAPNAME} title="SRTM version 4.1 250M resolution, W hemisphere" mult=1.0 


# r.in.bin -s -b  --o input=W100N40.DEM output=W100N40 title="GTOPO DEM W100N40" bytes=2 cols=4800 anull=-9999 north=40 south=-10 east=-60 west=-100 rows=6000
 r.colors map=${MAPNAME} rules=elevation


# EOF 
