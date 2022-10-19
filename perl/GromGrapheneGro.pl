#!/usr/bin/perl

use strict;
use warnings;

&main();

# ARGV[0] is the gro file
# ARGV[1] is the graphene pdb
# ARGV[2] is the out gro file

sub main {
    my @PrevGroLines;
    my $PreviousAtomNum;
    my $GroTitle;
    my $Dimensions;
    my $lineCount = 0;

    open(GRO, "$ARGV[0]") || die "unable to open $ARGV[0] in subroutine main\n";
    
    $lineCount++ while <GRO>;

    seek(GRO, 0, 0);

    my $maxZ = 0;
    my $minZ = 10000;

    my $newLineCount = 0;
    while(<GRO>) {
        $newLineCount++;
        if ($newLineCount == 1) {
            $GroTitle = $_;
        } elsif ($newLineCount == 2) {
            $PreviousAtomNum = $_;
        } elsif ($newLineCount == $lineCount) {
            $Dimensions = $_;
        } else {
            push(@PrevGroLines, $_);
            my $z = substr($_,37,7);

            if ($z > $maxZ && /DPPC/) {
                $maxZ = $z;
            }

            if ($z < $minZ && /DPPC/) {
                $minZ = $z;
            }
        }
    }

    close(GRO);

    my $LastMolNum;
    if ($PrevGroLines[-2] =~ /^\s*([0-9]+)[A-Z]*/) {
        $LastMolNum = $1;
    }
    
    open(PDB, "$ARGV[1]") || die "unable to open $ARGV[1] in subroutine main\n";

    my @X;
    my @Y;
    my $AtomCount = 0;

    while(<PDB>) {
        if (/ATOM/) {
            $AtomCount++;
            my @tempLine = split(/\s+/, $_);
            push(@X, $tempLine[5]);
            push(@Y, $tempLine[6]);
        }
    }

    my $DimensionsCopy = $Dimensions;
    $DimensionsCopy =~ s/^\s+|\s+$//g;
    my @splitDimensions = split(/\s+/, $DimensionsCopy);

    my $adjustX = (mean(@X) / 10) - ($splitDimensions[0] / 2);
    my $adjustY = (mean(@Y) / 10) - ($splitDimensions[1] / 2);

    seek(PDB, 0, 0);
    my @NewGroLinesFlake1;
    my @NewGroLinesFlake2;

    while(<PDB>) {
        if (/ATOM/) {
            $_ =~ s/^\s+|\s+$//g;
            my @splitLine = split(/\s+/, $_);
            my $lineFlake1 = sprintf("%5d%-5s%5s%5d%8.3f%8.3f%8.3f%8.4f%8.4f%8.4f\n", $LastMolNum + 1, "GP001", $splitLine[2], $splitLine[1] + $PreviousAtomNum, ($splitLine[5] / 10) - $adjustX, ($splitLine[6] / 10) - $adjustY, $maxZ + .15, 0, 0, 0);
            my $lineFlake2 = sprintf("%5d%-5s%5s%5d%8.3f%8.3f%8.3f%8.4f%8.4f%8.4f\n", $LastMolNum + 2, "GP001", $splitLine[2], $splitLine[1] + $PreviousAtomNum + $AtomCount, ($splitLine[5] / 10) - $adjustX, ($splitLine[6] / 10) - $adjustY, $minZ - .15, 0, 0, 0);
            push(@NewGroLinesFlake1, $lineFlake1);
            push(@NewGroLinesFlake2, $lineFlake2);
        }
    }
    
    close(PDB);

    open(OUT, ">$ARGV[2]") || die "unable to open $ARGV[2] in subroutine main\n";

    print OUT $GroTitle;
    print OUT $PreviousAtomNum + 2 * $AtomCount, "\n";

    foreach (@PrevGroLines) {
        print OUT $_;
    }

    foreach (@NewGroLinesFlake1) {
        print OUT $_;
    }

    foreach (@NewGroLinesFlake2) {
        print OUT $_;
    }

    print OUT $Dimensions;

    close(OUT);

}

sub sum {
    my (@Array) = @_;
    my $Sum = 0;

    map {
        $Sum += $_;
    } @Array;

    return $Sum;
}

sub mean {
    my (@Array) = @_;

    return (sum(@Array) / @Array); 
}
