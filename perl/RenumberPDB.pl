#!/usr/bin/perl

open(FILE,'/home/philip/HomeDir/misc/PDB_Files/DPPC_BilayerC.pdb') || die 'fuck my code sucks';
open(OUT,'>/home/philip/HomeDir/misc/PDB_Files/DPPC_BilayerN.pdb') || die 'goddamn I blow';
while(<FILE>) {
    if(/ATOM|HETATM/) {
        $count++;
        $lineP2=sprintf("%5s",$count);
        $lineP1=substr($_,0,6);
        $lineP3=substr($_,11);
        $line="$lineP1" . "$lineP2" . "$lineP3";
        print OUT $line;
    }
    else {
        print OUT $_;
    }
}