#!/usr/bin/perl
use List::Util qw(max min);

my %LINE;
my $new_Z;
my @DPPC_mol;
my @split_line;
my @DPPC_molp;
#open(FILE,'/home/philip/HomeDir/misc/LAMMPS_Data_Files/DPPC_Bilayer_c.data');
open(FILE,"<-") || die "unable to open in file";
open(OFILE,">-") || die "unable to open out file";
while(<FILE>) {
    $i++;
    @split_line=split(/\s+/,$_);
    if(/ 30\.974$/) {
        $Phosph_Code = @split_line[0];
    }
    if(/zlo/) {
        $Z=@split_line[1]-@split_line[0];
    }
    if ($#split_line == 9 && (@split_line[2]==16 || @split_line[2]==17) && @split_line[6] < 0 && @split_line[9] == 0) {
        $new_Z= @split_line[6]+ $Z;
        $string= "@split_line[0] " . "@split_line[1] " . "@split_line[2] " . "@split_line[3] " . "@split_line[4] " . "@split_line[5] " . "$new_Z " . "@split_line[7] " . "@split_line[8] " . "0\n";
        $LINE{$i}=$string;
    }
     if ($#split_line == 9 && (@split_line[2]==16 || @split_line[2]==17) && @split_line[6] < 0 && @split_line[9] == 1) {
        $new_Z= @split_line[6]+ $Z;
        $string= "@split_line[0] " . "@split_line[1] " . "@split_line[2] " . "@split_line[3] " . "@split_line[4] " . "@split_line[5] " . "$new_Z " . "@split_line[7] " . "@split_line[8] " . "0\n";
        $LINE{$i}=$string;
    }
    if ($#split_line == 9 && (@split_line[2]==16 || @split_line[2]==17) && @split_line[6] > 0 && @split_line[9] == -1) {
        $new_Z= @split_line[6];
        $string= "@split_line[0] " . "@split_line[1] " . "@split_line[2] " . "@split_line[3] " . "@split_line[4] " . "@split_line[5] " . "$new_Z " . "@split_line[7] " . "@split_line[8] " . "0\n";
        $LINE{$i}=$string;
    }
    if (@split_line[6] < 0 && @split_line[2]==$Phosph_Code && $#split_line == 9) {
        push(@DPPC_mol,@split_line[1]);
    }
    if (@split_line[6] > 0 && @split_line[2]==$Phosph_Code && $#split_line == 9) {
        push(@DPPC_molp,@split_line[1])
    }
}
seek FILE,0,0;
while(<FILE>) {
    $g++;
    @split_line=split(/\s+/,$_);
    foreach $DPPC_mol (@DPPC_mol) {
        if (@split_line[1]==$DPPC_mol && $#split_line == 9 && @split_line[2]!=16 && @split_line[2]!=17) {
            $new_Z= @split_line[6]+ $Z;
            $string= "@split_line[0] " . "@split_line[1] " . "@split_line[2] " . "@split_line[3] " . "@split_line[4] " . "@split_line[5] " . "$new_Z " . "@split_line[7] " . "@split_line[8] " . "0\n";
            $LINE{$g}=$string;
        }
    }
}
seek FILE,0,0;
while(<FILE>) {
    $h++;
    $check=0;
    @split_line=split(/\s+/,$_);
    foreach $DPPC_molp (@DPPC_molp) {
        if (@split_line[1]==$DPPC_molp && $#split_line == 9 && @split_line[2]!=16 && @split_line[2]!=17) {
            $LINE{$h}=$_;
        }
    }
    if($#split_line != 9) {
        $LINE{$h}=$_;
    }
    if($#split_line == 9 && (@split_line[2]==16 || @split_line[2]==17) && @split_line[6] > 0 && @split_line[9]!=-1) {
        $LINE{$h}=$_;
        $w++;
    }
}
for ($f=0;$f<$i;$f++) {
    print $LINE{$f};
}

