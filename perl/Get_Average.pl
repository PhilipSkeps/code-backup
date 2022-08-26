#!/usr/bin/perl

use List::Util qw(sum);

print "how many lipids were simulated:\t";
$NoL=<>;
chop $NoL;

sub mean {
    $array=shift;
    @array=@$array;
    $average=(sum(@array)/(@array));
    return $average;
}

$Vw = 0.0314;

open(WFILE,"/home/philip/HomeDir/misc/LAMMPS_Result_Files/expdataw.sim") || die "unable to open the wfile";
while (<WFILE>) {
    @split_line=split(/\s+/,$_);
    if ( @split_line[0] >= 2200000 ) {
        $volumepw=(@split_line[1]/5000000);
        push(@volumepw,$volumepw);   
    }
}

#$avolumepw=&mean(\@volumepw);
#$Vw = $avolumepw;

open(FILE,"/home/philip/HomeDir/misc/LAMMPS_Result_Files/testdata.sim") || die "unable to open the file";
while (<FILE>) {
    @split_line=split(/\s+/,$_);
    if ( @split_line[0] >= 4000000 ) {
        $volumepL=(((@split_line[1]/1000)-(2160*$Vw))/($NoL));
        $z_L=(@split_line[2]/10);
        $areapL=(2*@split_line[3])/(100*$NoL);
        push(@volumepL,$volumepL);
        push(@z_L,$z_L);
        push(@areapL,$areapL);
    }
}


$avolumepL=&mean(\@volumepL);
$az_L=&mean(\@z_L);
$aareapL=&mean(\@areapL);

print "Water Volume: $avolumepw\n";
print "Lipid Volume: $avolumepL\n";
print "Area Lipid: $aareapL\n";
print "Z Value for tank: $az_L\n";

