#!/usr/bin/perl

&main();



sub main() {
    
    (my $FIN, my $ATOM_CUT) = &gather();
    open(INFILE , '<' , $FIN)  || die "unable to open $FIN";
    $FIN =~ s/.top$//;
    $FINMOD = $FIN . "_mod.top";
    open(OUT , '>' , $FINMOD) || die "unable to open $FINMOD";

    while(<INFILE>) {

        if (/\[ dihedrals \]/) { $i = 0 } # end bound for change

        my $line = $_;
        $line =~ s/^\s+|\s+$//g; # trim white space
        my @split_line = split(/\s+/,$line); # split bitch

        if ( $i == 1 && ( @split_line[0] <= $ATOM_CUT || @split_line[0] <= $ATOM_CUT ) && @split_line[0] =~ /^[0-9]*$/) {
            # do nothing
        }
        else {
            print OUT $_; # if above fails we are good therefore add to processed file
        }

        if (/\[ bonds \]/) { $i = 1 } # set bound for change
    
    }
    
    close(INFILE);
    close(OUT);
    
}



sub gather() {

    #my $IN = "/home/pskeps/HomeDir/misc/GromTest/water_dppc.top";
    #my $TOT_WATER = 2188 * 3;

    my $IN = $ARGV[0]; # filename
    my $TOT_WATER = 3 * $ARGV[1]; # number water
    return($IN,$TOT_WATER);

}