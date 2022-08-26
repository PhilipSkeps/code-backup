#!usr/bin/perl

use lib "/home/philip/bin/perl/OOPtest";
use testOOP;

use strict;
use warnings;

&main;

sub main {
    my $testOP1 = TestOP->init({x=>1, y=>2, z=>3});
    my $testOP2 = TestOP->init({x=>2, y=>3, z=>4});

    my $testMult = $testOP1->mult($testOP2);

    print $testMult->getX, " ", $testMult->getY, " ", $testMult->getZ, "\n";
}