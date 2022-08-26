#!/usr/bin/perl

open(IFILE,'/home/philip/HomeDir/misc/LAMMPS_Data_Files/DPPC_Bilayer/DPPC_Bilayer.data') || die 'unable to open file loser';
open(OFILE,'>/home/philip/HomeDir/misc/LAMMPS_Data_Files/DPPC_Bilayer/DPPC_Bilayer.new') || die 'unable to open out file bitch';
while(<IFILE>) {
    if ( /0.834/ ) {
        $_=~s/0.834/0.830/;
    }
    if ( /0.417/ ) {
        $_=~s/0.417/0.415/;
    }
    print OFILE $_;
}