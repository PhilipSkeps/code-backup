#!/usr/bin/perl
use List::Uniq ':all';

print 'give me a PDB File to modify:   ';
$PDB_FILE=<>;
chop($PDB_FILE);
print 'how big of a radius would you like me to remove:   ';
$RADIUS=<>;
$NFILE= $PDB_FILE . "r";
open(PDBFILE,"/home/pskeps/HomeDir/misc/PDB_Files/$PDB_FILE") || die "unable to open $PDB_FILE";
open(OUT,">/home/pskeps/HomeDir/misc/PDB_Files/$NFILE") || die "unable to open out file";
while(<PDBFILE>) {
    @split_line=split(/\s+/,$_);
    if (/DPPC/) {
        $X=@split_line[5];
        $Y=@split_line[6];
        $Z=@split_line[7];
        ($distance)=distance_calc($X,$Y);
        if ($distance <= $RADIUS && $Z >= 0) {
            push(@RemoveMol,@split_line[4]);
        }
    }
}

@RemoveMol_uniq=uniq(@RemoveMol);
seek(PDBFILE,0,0);

while(<PDBFILE>) {
    @split_line=split(/\s+/,$_);
    if (/DPPC/) {
        map {
            if (/^@split_line[4]$/) {
                $i=1;
            }
        } @RemoveMol_uniq;
        if ($i==0) {
            print OUT $_;
        }
        $i=0;
    }
    else {
        print OUT $_;
    }
}


sub distance_calc {
	my $X1 = @_[0];
	my $Y1 = @_[1];
	my $X2=0;
	my $Y2=0;
	my $distance;
	$distance=sqrt( ( $X2 - $X1 )**2 + ( $Y2 - $Y1 )**2 );
	return($distance);
}