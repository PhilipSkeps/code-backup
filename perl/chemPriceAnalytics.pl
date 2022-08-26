#!/usr/bin/perl

use Term::ANSIColor;
use LWP::Simple;

use statFunc;

# abandonned project would need a auto quoting system 
# could do something similiar involving more readily available prices
# auto quoting would involve chinese websites and a faked company title with email

@COSTSITES = ("https://dir.indiamart.com/search.mp?ss=");
$CASSITE  = "https://commonchemistry.cas.org/results?q=";

&main();


# unit conversion function
# ? confidence interval
# find more websites
# data grabber function

sub main() {

    do {

        print "What chemical should I search via CAS number?";
        #my $userIn = <>;
        my $userIn = "142-82-5";
        my $chemName = &searchCASSites($userIn);

        if($chemName eq "ERROR") {
            print "please give a valid CAS number";
            continue;
        } else {
            my $data_ref = &searchCostSites($chemName);
            my @data = @$data_ref;
        }
        
    } while($userIn ne "done");

}



sub searchCASSites() {

    my $casName = shift;
    my $chemName;
    
    my $linkCas = $CASSITE . $casName;
    my $curlOutCas = get($linkCas) || die "unable to retrieve content";
    
    if ( $curlOutCas =~ m/"Substance Result: $casName, ([aA-zZ]+)"/ ) {
        $chemName = $1;
    } else {
        print color("red"), "ERROR UNABLE TO FIND CHEMICAL NAME FROM CAS", color("reset");
        my $chemName = "ERROR";
    }

    return($chemName);

}



sub searchCostSites() {
    
    my $chemName = shift;
    my @data;

    map {

        my $linkCost = $_ . $chemName;
        my $curlOutCost = get($linkCost) || die "unable to retrieve content";
        push(@data,$curlOutCost);

    } @COSTSITES;

    return \@data;
}



sub printSources() {

    # may need to have shift for if no finding in some sites
    if ( $CASSITE =~ /(^.*\.[a-z]{2,3})\//) { print "cas Site: $1\n" }

    print "cost sites: ";

    map { 
        if ( $_ =~ /(^.*\.[a-z]{2,3})\//) { print "$1\n\t    "} 
    } @COSTSITES;

    
}


sub dataGrabber() {
    my $data_ref = shift;
    @data = @$data_ref;

}


