#!/usr/bin/perl
$count=0;
open(FILE,"/home/philip/HomeDir/misc/PDB_Files/Water_slab.pdb") || die 'unable to open file';
open(OUT,">/home/philip/HomeDir/misc/PDB_Files/Water_slab_n.pdb") || die 'out file unprint';
while(<FILE>) {
    if ( $_ !~ /DPPC|ATOM|TER/ ) {
        print OUT $_;
    }
    if ( $_ !~ /DPPC/ && $_ =~ /ATOM/ ) {
        $count++;
        $line1=substr($_,0,4);
        $line2=substr($_,12);
        printf OUT "$line1 %5s $line2", $count;
    }
}