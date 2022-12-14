#!/usr/bin/perl

use strict;
use warnings;

&main();

# ARGV[0] => user built topology
# ARGV[1] => CHARMMGUI built topology

sub main {

    my ($Atoms1, $Bonds1, $Pairs1, $Angles1, $Dihedrals1, $Restraints1) = readFile($ARGV[0]);
    my ($Atoms2, $Bonds2, $Pairs2, $Angles2, $Dihedrals2, $Restraints2) = readFile($ARGV[1]);

    findError($Atoms1, $Atoms2, "Atoms");
    findError($Bonds1, $Bonds2, "Bonds");
    findError($Pairs1, $Pairs2, "Pairs");
    findError($Angles1, $Angles2, "Angles");
    findError($Dihedrals1, $Dihedrals2, "Dihedrals");
    findError($Restraints1, $Restraints2, "Restraints");

}

sub findError {
    my ($Array1, $Array2, $Type) = @_;

    open(OUT, ">$Type.txt") || die "unable to open $Type in subroutine findError\n";

    print OUT "Unknown:\n"; 

    my $error = 1;

    while ("@$Array1" ne "") {
        my $Element = shift(@$Array1);
        $error = 1;
        for (my $j = 0; $j < @$Array2; $j++) {
            if (compareFB($Element, ${$Array2}[$j])) {
                $error = 0;
                splice(@$Array2, $j, 1);
                last;
            }
        }
        if ($error) {
            print OUT "@$Element\n";
        }
    }

    while("@$Array1" ne "") {
        my $Element = shift(@$Array1);
        print OUT "@$Element\n";
    }

    print OUT "\nMissing:\n";

    while("@$Array2" ne "") {
        my $Element = shift(@$Array2);
        print OUT "@$Element\n";
    }

    close(OUT);
}

sub compareFB {
    my ($Array1, $Array2) = @_;

    if (${$Array1}[-1] ne ${$Array2}[-1]) {
        return 0;
    }

    if (${$Array1}[0] eq ${$Array2}[0]) { # compare forwards
        for (my $i = 1; $i < @$Array1 - 1; $i++) {
            if (${$Array1}[$i] ne ${$Array2}[$i]) {
                return 0;    
            }
        }
    } else { # enter compare backwards mode
        for (my $i = 0; $i < @$Array1 - 1; $i++) {
            if (${$Array1}[$i] ne ${$Array2}[-($i + 2)]) {
                return 0;
            }
        }
    }

    return 1;
}

sub readFile {
    my ($file) = @_;
    my @Atoms;
    my @Bonds;
    my @Pairs;
    my @Angles;
    my @Dihedrals;
    my @Restraints;

    my $switch = 0;

    open(FILE, "$file") || die "unable to open $file in subroutine readFile\n";
    while(<FILE>) {
        $_ =~ s/^\s+|\s+$//g;
        if ($_ !~ /^;|^#/) {

            # enter proper state
            if (/^\[ atoms \]/) {
                $switch = 1;
            } elsif (/^\[ bonds \]/) {
                $switch = 2;
            } elsif (/^\[ pairs \]/) {
                $switch = 3;
            } elsif (/^\[ angles \]/) {
                $switch = 4;
            } elsif (/^\[ dihedrals \]/) {
                $switch = 5;
            } elsif (/^\[ position_restraints \]/) {
                $switch = 6;
            }

            if (/^[0-9]/) {
                if ($switch == 1) {
                    my @splitLine = split(/\s+/, $_);
                    my @splitLineMatch = ($splitLine[0], $splitLine[1], $splitLine[3], $splitLine[4], $splitLine[5], $splitLine[6]);
                    push(@Atoms, \@splitLineMatch);
                } elsif ($switch == 2) {
                    my @splitLine = split(/\s+/, $_);
                    push(@Bonds, \@splitLine);
                } elsif ($switch == 3) {
                    my @splitLine = split(/\s+/, $_);
                    push(@Pairs, \@splitLine);
                } elsif ($switch == 4) {
                    my @splitLine = split(/\s+/, $_);
                    push(@Angles, \@splitLine);
                } elsif ($switch == 5) {
                    my @splitLine = split(/\s+/, $_);
                    push(@Dihedrals, \@splitLine);
                } elsif ($switch == 6) {
                    my @splitLine = split(/\s+/, $_);
                    push(@Restraints, \@splitLine);
                }
            }
        }
    }

    close(FILE);
    return(\@Atoms, \@Bonds, \@Pairs, \@Angles, \@Dihedrals, \@Restraints);
}


