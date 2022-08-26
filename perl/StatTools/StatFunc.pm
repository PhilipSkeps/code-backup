#!/usr/bin/perl

package StatFunc;

use strict;
use warnings;

sub max {
    my @Args = @_;
    my $max = $Args[0];

    for (my $i = 1; $i < @Args; $i++) {
        if ( $Args[$i] > $max ) {
            $max = $Args[$i];
        }
    }

    return $max;
}

sub min {
    my @Args = @_;
    my $min = $Args[0];

    for (my $i = 1; $i < @Args; $i++) {
        if ( $Args[$i] > $min ) {
            $min = $Args[$i];
        }
    }

    return $min;
}

1;