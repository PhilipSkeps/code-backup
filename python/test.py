#!/usr/bin/python

import sys
import re

file = sys.argv[1] # look at command line argument 1
outfile = re.sub(".pdb", "_mod.pdb", file) # water_dppc.pdb  outfile now contains water_dppc_mod.pdb
savedlines = [] # intializing an empty list 

print(outfile) 

outfh = open(outfile, 'a')

with open(file, "r") as fh:
    lines = fh.readlines()

for line in lines:
    if( bool(re.search("TIP|END" , line)) ): # regex find water then store line
        savedlines.append(line)
    else:
        outfh.write(line) # to file what needs to be everything else

for line in savedlines:
    outfh.write(line) # to file all the water stuff just at the end 

outfh.close() # close 



# if I had like the "fox jumped the brown fence"
# the fox jumped over the water molecule and its residue was TIP"
# "the string containes a END"