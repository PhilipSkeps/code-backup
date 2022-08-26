#!/usr/bin/perl

chdir('/home/philip/HomeDir/misc/LAMMPS_Result_Files/') || die 'unable to open directory'; 
print "give me a file to abbreviate:    ";
$FILE=<>;
chop $FILE;
open(FILE,$FILE) || die 'unable to open file';
$out="$FILE" . "brev";
open(OUT,">$out") || die 'unable to open out';
print "How many Data points would you like:  ";
$NUMBER=<>;
chop $NUMBER;
while(<FILE>) {
    $i++;
}
seek(FILE,0,0);
$EVERY=($i-1)/$NUMBER;
$EVERY=int($EVERY);
$check=1;
$i=0;
while(<FILE>) {
    $i++;
    if ($check==1 && $i==2) {
        $check=0;
        $i=0;
        print OUT "$_";
    }
    if ($i==$EVERY && $check==0) {
        print OUT "$_";
        $i=0;
    }
}
