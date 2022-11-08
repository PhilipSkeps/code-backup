#!/usr/bin/perl

#ARGV[0] => .top in file
#ARGV[1] => .top out file

use strict;
use warnings;

&main();

sub main {
    open(TOP, "$ARGV[0]") || die "unable to open $ARGV[0]\n";

    my @BeforeLines;
    my @AfterLines;

    my $switch = 0;

    while(<TOP>) {
        if (/\[ system \]/) {
            $switch = 1;
        }

        if ($switch) {
            push(@AfterLines, $_);
        } else {
            push(@BeforeLines, $_);
        }
    }

    close(TOP);

    open(OUT, ">$ARGV[1]") || die "unable to open $ARGV[1]\n";

    foreach (@BeforeLines) {
        print OUT $_;
    }

    print OUT "\n\n; Include topology for graphene\n";
    print OUT '#include "./NMA.itp"';
    print OUT "\n\n";

    foreach (@AfterLines) {
        print OUT $_;
    }

    printf OUT ("NMA%18s", 2);
}