#!/usr/bin/perl

print "give a graphene file to doctor\n";
$FILE=<>;
$WRITEFILE=$FILE;
$WRITEFILE=~s/\.pdb/_inp\.pdb/;
chdir('/home/philip/HomeDir/misc/PDB_Files') || die "unable to open /home/philip/HomeDir/misc/PDB_Files";
open(FILE,$FILE) || die "unable to open $FILE";
open(WRITEFILE,">$WRITEFILE");
while(<FILE>) {
    if (/^HETATM/ || /^ATOM/ || /^TER/ || /^HELIX/ || /^SHEET/ || /^SSBOND/) {
        $first_piece=substr($_,0,17);
        $check=substr($_,17,4);
        $second_piece=substr($_,21);
        $first_piece= $first_piece . "GRPH";
        if ($check eq "    ") {
            print WRITEFILE "$first_piece$second_piece";
        }
        else {
            $_=~s/MOL |METH|DPP /DPPC/;
            print WRITEFILE $_;
        }
    }
    elsif ( /^[^CONECT]/ ) {
        print WRITEFILE $_;
    }
}
