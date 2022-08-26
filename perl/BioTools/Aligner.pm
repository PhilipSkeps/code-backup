#!/usr/bin/perl

use lib "/home/philip/bin/perl/StatTools";
use StatFunc;

use strict;
use warnings;

package Aligner;

use constant {
    INDEL_SC => -1,
    MISMATCH_SC => -1,
    MATCH_SC => 1
};

my %bitDNAMap = (
    A => 0b0001,
    T => 0b0010,
    G => 0b0100,
    C => 0b1000,
    N => 0b1111
);

sub seqToBit {
    my ($Seq1) = @_;
    my @Seq1Char = split(//,$Seq1);
    my @Seq1Bit;

    map { push(@Seq1Bit, $bitDNAMap{$_}); } @Seq1Char;

    return \@Seq1Char;
}

sub alignScoreTable {
    my ($Seq1Bit, $Seq2Bit) = @_;
    my @Seq1Bit = @$Seq1Bit;
    my @Seq2Bit = @$Seq2Bit;

    my @ScoreTable;
    my $compareVal;

    for (my $i = 0; $i < @Seq1Bit; $i++) {
        $ScoreTable[$i][0] = INDEL_SC * $i;
    }
    for (my $j = 0; $j < @Seq2Bit; $j++) {
        $ScoreTable[0][$j] = INDEL_SC * $j;
    }

    for (my $i = 1; $i < @Seq1Bit; $i++) {
        for (my $j = 1; $j < @Seq2Bit; $j++) {
            my $matchScore;
            if ($Seq2Bit[$j] & $Seq1Bit[$i]) {
                $matchScore = $ScoreTable[$i - 1][$j - 1] + MATCH_SC;
            } else {
                $matchScore = $ScoreTable[$i - 1][$j - 1] + MISMATCH_SC;
            }

            my $insertScore = $ScoreTable[$i - 1][$j] + INDEL_SC;
            my $deleteScore = $ScoreTable[$i][$j - 1] + INDEL_SC;         
        
            $ScoreTable[$i][$j] = StatFunc::max($insertScore, $deleteScore, $matchScore);
        }
    }

    return \@ScoreTable;
}

sub align {
    my ($Seq1, $Seq2) = @_;

    my $alignedSeq1;
    my $alignedSeq2;

    my @Seq1Char = split(//,$Seq1);
    my @Seq2Char = split(//,$Seq2);

    my $Seq1Bit = seqToBit($Seq1);
    my $Seq2Bit = seqToBit($Seq2);

    my $Table = alignScoreTable($Seq1Bit, $Seq2Bit);
    my @Table = @$Table;

    my $i = @Seq1Char;
    my $j = @Seq2Char;

    while($i ne 0 && $j ne 0) {
        if ($Table[$i][$j] == $Table[$i - 1][$j] + INDEL_SC) {
            $alignedSeq1 .= "N";
            $alignedSeq2 .= $Seq2Char[$i];
            $i--;
        } elsif ($Table[$i][$j] == $Table[$i][$j - 1] + INDEL_SC) {
            $alignedSeq1 .= $Seq1Char[$j];
            $alignedSeq2 .= "N";
            $j--; 
        } else {
            $alignedSeq1 .= $Seq1Char[$i];
            $alignedSeq2 .= $Seq2Char[$j];
            $i--;
            $j--;
        }
    }

    return ($alignedSeq1, $alignedSeq2);
}

1;