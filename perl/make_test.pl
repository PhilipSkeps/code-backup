#!/usr/bin/perl

chdir("/home/pskeps/HomeDir/misc/LAMMPS_Result_Files/");
open(FILE,"DPPC_Graf_19rings_54ApL.results") || die 'booty';
open(OUT,">foobar_test.results");
while(<FILE>) {
    if (/ITEM: TIMESTEP/) {
        $i++;
    }
    if ($i==3) {
        exit;
    }
    print OUT $_;
}