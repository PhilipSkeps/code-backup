#!/usr/bin/perl


use mathPlus;

for(my $i = 0; $i <= 10; $i++ ) {
    push(@X,$i*.01);
}

for(my $i = 0; $i < @X; $i++) {
    push(@Y,@X[$i] ** 2);
}



($X,$Y) = mathPlus::fFirstDeriv(\@X,\@Y);

map {print "$_ "} @$Y;