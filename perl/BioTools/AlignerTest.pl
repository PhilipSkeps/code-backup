#!/usr/bin/perl

use lib "/home/philip/bin/perl/BioTools";
use Aligner;

use strict;
use warnings;

&test();

sub test {
    my $Seq1 = "GCATGCG";
    my $Seq2 = "GATTACA";

    my ($alignedSeq1, $alignedSeq2) = Aligner::align($Seq1,$Seq2);

    print $alignedSeq1, "\n", $alignedSeq2, "\n";
}