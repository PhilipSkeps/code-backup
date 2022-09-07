#!/usr/bin/perl

package MathPlus;

use Term::ANSIColor;

use strict;
use warnings;

# should include finite element analysis subroutine

sub fFirstDeriv {

    my ($arrayX_ref, $arrayY_ref) = @_;
    my @arrayX = @$arrayX_ref;
    my @arrayY = @$arrayY_ref;

    my $arrayLengthX = @arrayX;
    my $arrayLengthY = @arrayY;

    my @arrayOutX;
    my @arrayOutY;

    if ( &__WARN__($arrayLengthX,$arrayLengthY) ) { exit -1 }

    for( my $i = 0; $i < $arrayLengthX - 1; $i++ ) {

        my $derivVal = ( $arrayY[$i + 1] - $arrayY[$i] ) / ( $arrayX[$i + 1] - $arrayX[$i] );
        push(@arrayOutY,$derivVal);
        push(@arrayOutX,$arrayX[$i]);

    }

    return(\@arrayOutX,\@arrayOutY);

}



sub bFirstDeriv {

    my ($arrayX_ref, $arrayY_ref) = @_;
    my @arrayX = @$arrayX_ref;
    my @arrayY = @$arrayY_ref;

    my $arrayLengthX = @arrayX;
    my $arrayLengthY = @arrayY;

    my @arrayOutX;
    my @arrayOutY;

    if ( &__WARN__($arrayLengthX,$arrayLengthY) ) { exit -1 }

    for( my $i = 1; $i < $arrayLengthX; $i++ ) {

        my $derivVal = ( $arrayY[$i] - $arrayY[$i - 1] ) / ( $arrayX[$i] - $arrayX[$i - 1] );
        push(@arrayOutY,$derivVal);
        push(@arrayOutX,$arrayX[$i]);

    }

    return(\@arrayOutX,\@arrayOutY);

}



sub mFirstDeriv {

    my ($arrayX_ref, $arrayY_ref) = @_;
    my @arrayX = @$arrayX_ref;
    my @arrayY = @$arrayY_ref;

    my $arrayLengthX = @arrayX;
    my $arrayLengthY = @arrayY;

    my @arrayOutX;
    my @arrayOutY;

    if ( &__WARN__($arrayLengthX,$arrayLengthY) ) { exit -1 }

    for( my $i = 1; $i < $arrayLengthX - 1; $i++ ) {

        my $derivVal = ( $arrayY[$i + 1] - $arrayY[$i - 1] ) / ( ( $arrayX[$i + 1] - $arrayX[$i - 1] ) );
        push(@arrayOutY,$derivVal);
        push(@arrayOutX,$arrayX[$i]);

    }

    return(\@arrayOutX,\@arrayOutY);

}



sub mSecondDeriv {

    my ($arrayX_ref, $arrayY_ref) = @_;
    my @arrayX = @$arrayX_ref;
    my @arrayY = @$arrayY_ref;

    my $arrayLengthX = @arrayX;
    my $arrayLengthY = @arrayY;

    my @arrayOutX;
    my @arrayOutY;

    if ( &__WARN__($arrayLengthX,$arrayLengthY) ) { exit -1 }

    for( my $i = 1; $i < $arrayLengthX - 1; $i++ ) {

        my $derivVal = ( $arrayY[$i + 1] - 2 * $arrayY[$i] + $arrayY[$i - 1] ) / ( ( $arrayX[$i + 1] - $arrayX[$i] ) ** 2 );
        push(@arrayOutY,$derivVal);
        push(@arrayOutX,$arrayX[$i]);

    }

    return(\@arrayOutX,\@arrayOutY);

}



sub lRiemannSum {

    my ($arrayX_ref, $arrayY_ref) = @_;
    my @arrayX = @$arrayX_ref;
    my @arrayY = @$arrayY_ref;

    my $arrayLengthX = @arrayX;
    my $arrayLengthY = @arrayY;

    my $SUM = 0;

    if ( &__WARN__($arrayLengthX,$arrayLengthY) ) { exit -1 }

    for(my $i = 0; $i < $arrayLengthX - 1; $i++) {
        $SUM += $arrayY[$i] * ( $arrayX[$i + 1] - $arrayX[$i] );
    }

    return($SUM);

}



sub rRiemannSum {

    my ($arrayX_ref, $arrayY_ref) = @_;
    my @arrayX = @$arrayX_ref;
    my @arrayY = @$arrayY_ref;

    my $arrayLengthX = @arrayX;
    my $arrayLengthY = @arrayY;

    my $SUM = 0;

    if ( &__WARN__($arrayLengthX,$arrayLengthY) ) { exit -1 }

    for(my $i = 1; $i < $arrayLengthX; $i++) {
        $SUM += $arrayY[$i] * ( $arrayX[$i] - $arrayX[$i - 1] );
    }

    return($SUM);

}



sub trapSum {

    my ($arrayX_ref, $arrayY_ref) = @_;
    my @arrayX = @$arrayX_ref;
    my @arrayY = @$arrayY_ref;

    my $arrayLengthX = @arrayX;
    my $arrayLengthY = @arrayY;

    my $SUM = 0;

    if ( &__WARN__($arrayLengthX,$arrayLengthY) ) { exit -1 }

    for(my $i = 1; $i < $arrayLengthX; $i++) {
        $SUM += ( ( $arrayY[$i] + $arrayY[$i - 1] ) * ( $arrayX[$i] - $arrayX[$i - 1] ) ) / 2;
    }

    return($SUM);

}



sub __WARN__ {

    # maybe check for numerical values
    
    my ($arrayLengthX, $arrayLengthY) = @_;

    if( $arrayLengthX != $arrayLengthY || $arrayLengthX == 0) {
        print color("red"), "Passed Numerical Arrays Are Not Equal or Are of Zero Length", color("reset");
        return 1;
    } else {
        return 0;
    }

}

1;