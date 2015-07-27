# FourThirdsPaper
Four-thirds radio propagation graph paper, made using [GNUplot]
(http://www.gnuplot.info/) and, for some items, [LaTeX](http://www.latex-project.org/).

If you don't know what radio propagation paper is, or what the 4:3 ratio even means, [read this Wikipedia Article first.](https://en.wikipedia.org/wiki/Non-line-of-sight_propagation)

You might also want to read NAVELEX 0101,112, from May 1972
as a useful extra study, found at [navy-radio.com](http://www.navy-radio.com),
[virhistory.com](http://www.virhistory.com/navy/manuals/shore-commsta.htm), and doubtlessly elsewhere.

I found that I needed this paper and couldn't find any online
(EDIT: added links below).

I have an example in the [*International Microwave Handbook*,
second edition](https://www.arrl.org/shop/International-Microwave-Handbook/) (Andy Barter, G8ATD, ed.), and found a copy of a 
sheet of this kind of paper. I re-did the math myself 
(*caveat emptor*) and confirmed that the tangents matched up 
pretty well. 

I did find two downloadable sheets at 
[eeweb.com](http://www.eeweb.com/electronics-forum/43-earth-radius-graphs-used-for-rf-link-design) --
[this one](http://s.eeweb.com/members/cody_miller/answers/1308244362-4-3-earth.pdf) and [this one](http://s.eeweb.com/members/cody_miller/answers/1308342903-4-3EarthRadius2.pdf), so interested users might like those as well. 

--Jesse Hamner, June 2015

Revision 1, Jul 24 2015:
------------------------

Added a variant of the script that allows users to include an elevation profile that will be plotted on the page in red, along with the option for labels identifying relevant locations along the profile.

The profile automatically adjusts its minimum elevation to be zero, so for those of you who live at 3000 meters elevation, your lowest profile elevation will still be zero meters.

I made my profiles using [GRASS GIS](http://grass.osgeo.org/), specifically its [r.profile](http://grass.osgeo.org/grass64/manuals/r.profile.html) module. 

To make this elevation profile, I used GRASS GIS and the [GTOPO30](https://lta.cr.usgs.gov/GTOPO30) DEM global elevation data set (small Wikipedia stub is [here](https://en.wikipedia.org/wiki/GTOPO30)). Thus the <tt>r.profile</tt> command includes a map and GRASS LOCATION name that are specific to that elevation raster. I expect yours will be different.

GTOPO30 DEM (digital elevation model) binary files are mostly 40 degrees wide (E-W) and 50 degrees tall (N-S), with exceptions near the South Pole that I won't go into.

Without seeking to become a serious tutorial on GRASS GIS (see the [GRASS-WIKI](http://grasswiki.osgeo.org/wiki/GRASS_Help) for that), to import a single GTOPO30 DEM, you would create a proper MAPSET and LOCATION, with a spatial (raster) resolution of 0.0083333 degrees, and type: 
```
g.region --o save="GTOPO_earth" n=90 s=-60 w=-180 e=180 res=0.0083333333333 --o

r.in.bin -s -b  --o input=W100N40.DEM output=W100N40 title="GTOPO DEM W100N40" bytes=2 cols=4800 anull=-9999 north=40 south=-10 east=-60 west=-100 rows=6000
r.colors map=W100N40 rules=elevation
```

You should pick your endpoints and use decimal degrees (noting that West and South are expressed as negative values). I use two example endpoints here.

Then, in GRASS, type:
```
r.profile --verbose input=W100N40@gtopo1 output=profile.txt profile=-80.8328,35.4911,-82.5558, 35.5800 res=0.011014
```

Note the resolution isn't critically important; I was doing that to try and get about 1 km of distance per data point as the crow flies, but the script doesn't care.

Similarly, to properly handle the labeling, one must create a separate file called <tt>labels.txt</tt> If you know your start and end points, you can use <tt>head</tt> and <tt>tail</tt> to create at least two of the points. You can add, by hand, other points along the profile as desired.
```
echo `head -n 1 profile.txt` " Davidson" > labels.txt
echo "86500.000 390 \"Blue Ridge Distilling Co\" " >> labels.txt
echo `tail -n 1 profile.txt` " Asheville" >> labels.txt
```
 
