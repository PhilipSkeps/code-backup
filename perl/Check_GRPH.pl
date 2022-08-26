#!/usr/bin/perl

my %Atom_Code;
my @Check_Angle;
my @Check_Dihedral;
my %array;
chdir("/home/philip/Desktop/charmm-gui-2128638439") || die "wrong directory dipshit";
print "Give me the Damn file to open\n" || die "Wrong file dipshit";
$FILE=<>;
chop $FILE;
open(FILE,"$FILE") || die "unable to open your file dip shit";
open(TESTDIH,">/home/philip/HomeDir/misc/LAMMPS_Data_Files/test/test.dih") || die "go fuck yourself";
open(TESTANG,">/home/philip/HomeDir/misc/LAMMPS_Data_Files/test/test.ang") || die "go fuck yourself angle";
open(COMPPDIH,"/home/philip/HomeDir/misc/LAMMPS_Data_Files/test/compare.pdih") || die "I hate my life";
open(COMPPANG,"/home/philip/HomeDir/misc/LAMMPS_Data_Files/test/compare.pang") || die "I hate my life angle";
open(COMPANG,">/home/philip/HomeDir/misc/LAMMPS_Data_Files/test/compare.ang") || die "I hate my life angle";
open(COMPDIH,">/home/philip/HomeDir/misc/LAMMPS_Data_Files/test/compare.dih") || die "I hate my life";
open(ARRAY,"/home/philip/HomeDir/misc/LAMMPS_Data_Files/test/array.array") || die "I hate my life array";
while(<FILE>) {
    if (/^\n$/) {
        $i=0;
    }
    if ($i==1) {
        $_=~s/^\s+//;
        @split_line=split(/\s+/,$_);
        $Atom_Code{@split_line[0]}=@split_line[4];
    }
    if (/\!NATOM/) {
        $i=1;
    }
    if ($i==2) {
        $_=~s/^\s+//;
        @split_line=split(/\s+/,$_);
        map {s/$_/$Atom_Code{$_}/} @split_line;
        while("@split_line" ne '') {
            ($a,$b,$c)=splice(@split_line,0,3);
            push(@Check_Angle,"1 1 $a $b $c");
        }
    }
    if (/\!NTHETA/) {
        $i=2;
    }
    if ($i==3) {
        $_=~s/^\s+//;
        @split_line=split(/\s+/,$_);
        map {s/$_/$Atom_Code{$_}/} @split_line;
        while("@split_line" ne '') {
            ($a,$b,$c,$d)=splice(@split_line,0,4);
            push(@Check_Dihedral,"1 1 $a $b $c $d");
        }
    }
    if (/\!NPHI/) {
        $i=3;
    }
}
while("@Check_Dihedral" ne '') {
    $Dih=shift(@Check_Dihedral);
    print TESTDIH "$Dih\n";
}
while("@Check_Angle" ne '') {
    $Ang=shift(@Check_Angle);
    print TESTANG "$Ang\n";
}
while(<ARRAY>) {
    @split_line=split(/\s+/,$_);
    $array{@split_line[0]}=@split_line[1];
}
while(<COMPPANG>) {
    $i=a;
    while($i ne 'y') {
        s/$i/$array{$i}/g;
        $i++;
    }
    print COMPANG $_;
}
while(<COMPPDIH>) {
    $i=a;
    while($i ne 'y') {
        s/$i/$array{$i}/g;
        $i++;
    }
    print COMPDIH $_;
}