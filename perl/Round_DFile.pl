#!/usr/bin/perl

open(FILE,'/home/philip/HomeDir/misc/LAMMPS_Data_Files/LDFB_test/LDFB_true.data') || die 'failure';
open(OUT,'>/home/philip/HomeDir/misc/LAMMPS_Data_Files/LDFB_test/LDFB_true1.data') || die 'bee pop';
while(<FILE>) {
    if (/Bond/) {
        $i=0;
    }
    if($i==1 && $_ !~ /^\n$/) {
        s/^\s+//;
        @split_line=split(/\s+/,$_);
        printf OUT ("%6s %6s %6s %9s %17.3f %17.3f %17.3f @split_line[7] @split_line[8]\n",@split_line[0],@split_line[1],@split_line[2],@split_line[3],@split_line[4],@split_line[5],@split_line[6])
    }
    else {
        print OUT $_;
    } 
    if (/Atoms/) {
        $i=1;
    }
}
