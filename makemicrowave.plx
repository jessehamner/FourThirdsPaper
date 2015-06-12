#!/usr/bin/perl
use warnings;
use strict;
my ($i, $style); 
for ($i=0; $i<=240; $i+= 4) 
{ 
    if ($i % 20 ) { $style= 3 } else { $style=2; }
    print "\t(x,ypos(offset1, x, halfarc, mult, $i ) ) ls $style , \\\n";
}
