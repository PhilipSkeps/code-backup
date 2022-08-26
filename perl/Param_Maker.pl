#!/usr/bin/perl

use List::Uniq ':all';

open(FILE,'/home/philip/Documents/LJ_DPPC') || die 'Unable to open LJ_DPPC';
open(OUT,">/home/philip/HomeDir/misc/LAMMPS_Data_Files/DPPC_test/DPPC_test.top") || die "file dont exist dawg";

my @com_Atom_Code_temp;
my @com_Atom_Code;
while(<FILE>) {
    @line=split(/\s+/,$_);
    push(@Atom_Code,@line[0]);
    push(@sigma,@line[1]);
    push(@epsilon,@line[2]);
}

map {
    $sigma1=$_;
    map {
        $com_sigma= (($sigma1 * $_)**(1/2));
        push(@com_sigma,$com_sigma);
    } @sigma; 
} @sigma;

map {
    $epsilon1=$_;
    map {
        $com_epsilon= (($epsilon1 * $_)**(1/2));
        push(@com_epsilon,$com_epsilon);
    } @epsilon; 
} @epsilon;

map {
    $Atom_Code1=$_;
    map {
        push(@com_Atom_Code_temp,"$Atom_Code1","$_");
        sort(@com_Atom_Code_temp);
        push(@com_Atom_Code,"@com_Atom_Code_temp[0] @com_Atom_Code_temp[1]");
        undef(@com_Atom_Code_temp);
    } @Atom_Code;
} @Atom_Code;


while("@com_sigma" ne '') {
    $SigmaN=shift(@com_sigma);
    $EpsilonN=shift(@com_epsilon);
    $Atom_CodeN=shift(@com_Atom_Code);
    push(@strings,"$Atom_CodeN $EpsilonN $SigmaN");
}

@uniq_Strings=uniq(@strings);
while("@uniq_Strings" ne '') {
    $uniq_Strings=shift(@uniq_Strings);
    print OUT "$uniq_Strings\n";
}


