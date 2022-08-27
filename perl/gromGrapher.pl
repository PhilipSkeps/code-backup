#!/usr/bin/perl

use CGI ':standard';
use GD::Graph::linespoints;
use List::Util qw(max min);

main();

sub main {

    ( $dataArray_ref, $titles_ref ) = grabData();

    my @dataArray = @$dataArray_ref;
    my @titles = @$titles_ref;
    my $numCol = @titles;

    for ( my $i = 1; $i < $numCol; $i++ ) {
        graphData( @titles[0], @titles[$i], @dataArray[0], @dataArray[$i] );
    }

}



sub grabData {
    my @titles;
    my $lineNum = 0;
    my $numDataC;
    my @dataArray;
    while (<>) {
        s/^\s+|\s+$//;
        my @splitLine = split(/\s+/, $_);
        if (/xaxis\s+label\s+"(.*)"/) {
            push(@title, $1);
        } elsif (/yaxis\s+label\s+"(.*)"/) {
            push(@title, $1);
        } elsif (/^@|#/) {
            continue
        } else {
            for ( my $colNum = 0; $colNum < $numDataC; $colNum++ ) {
               $dataArray[$colNum][$lineNum - 1] = @splitLine[$colNum];
            }    
        }
        $lineNum++;
    }
    return( \@dataArray, \@titles);
}



sub graphData {
    my $xTitle = shift;
    my $yTitle = shift;
    my $xAxisData = shift;
    my $yAxisData = shift;
    my $title = $yTitle . " in response to time " . $xTitle;
    my @data = ( $xAxisData, $yAxisData );
    my $graph = GD::Graph::linespoints -> new( 1920, 1080 );
    $graph -> set(  
        x_label => $xTitle ,
        y_label => $yTitle ,
        title   => $title ,
        y_min_value => min(@$yAxisData) ,
        y_max_value => max(@$yAxisData) ,
        x_min_value => min(@$xAxisData) ,
        x_max_value => max(@$xAxisData) ,
        x_tick_number => 2 ,
        transparent => 0 ,
        line_types => [ 1 ] ,
        line_width => 0 , 
        markers => [ 7 ] ,
        marker_size => 2 , 
        dclrs => [ qw( black ) ]
    );
    my $image = $graph -> plot(\@data); 
    my $fTitle = $title . ".png";
    open(OUT,">$fTitle") || die "unable to open $title for writing";
    print OUT $image -> png;
    close(OUT);
}