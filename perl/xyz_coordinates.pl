#!/usr/bin/perl

$^="COORDINATE_TOP";
$~="COORDINATE";
@X=();
@Y=();
@Z=();
print "what file would you like to return the atom coordinates for \n";
$TEMPFILE=<>;
open(PDBFILE,$TEMPFILE) || die "could not open the pdb file";
while (<PDBFILE>) {
($tempstring)=substr($_,32,24);
($x,$y,$z)=split(/\s+/, $tempstring);
write;}

format COORDINATE_TOP = 
X_COORDINATE Y_COORDINATE Z_COORDINATE
____________ ____________ ____________
.
format COORDINATE =
@<<<<<<<<<<< @<<<<<<<<<<< @<<<<<<<<<<<
$x,$y,$z
.

