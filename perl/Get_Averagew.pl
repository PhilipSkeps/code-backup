#!/usr/bin/perl

use List::Util qw(sum);

open(FILE,"/home/philip/HomeDir/misc/LAMMPS_Result_Files/expdataw.sim") || die "unable to open the file";
while (<FILE>) {
    @split_line=split(/\s+/,$_);
    if ( @split_line[0] >= 2200000 ) {
        $volumepw=(@split_line[1]/5000000);
        push(@volumepw,$volumepw);
    }
}

sub mean {
    my @array;
    $array=shift;
    @array=@$array;
    $average=(sum(@array)/(@array));
    return $average;
}


$avolumepw=&mean(\@volumepw);

print "Water Volume: $avolumepw\n";

