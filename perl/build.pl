#!/usr/bin/perl

open(OUT, ">>/home/philip/bin/cpp/LibPS/PreProcLoop.h") || die 'shit';
for(my $i = 0; $i < 10000; ++$i) {
    my $val = $i + 1;
    print OUT "\#if LOOP_START == $i\n";
    print OUT "\t\#undef LOOP_START\n";
    print OUT "\t\#define LOOP_START $val\n";
    print OUT "\#endif\n";
    #print OUT "\#define __MACRO_$i $i\n"
}
