#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long;
use CGI ':standard';
use GD::Graph::linespoints;
use List::Util qw(max min);
use lib "/home/pskeps/HomeDir/dev/perl/PM";
use StatFunc qw(mean sd);

main();

sub main {
    my ($infile, $xStart_ref, $xEnd_ref, $yStart_ref, $yEnd_ref) = parseCommand();

    my @xStart = @$xStart_ref;
    my @xEnd = @$xEnd_ref;
    my @yStart = @$yStart_ref;
    my @yEnd = @$yEnd_ref;

    my ( $dataArray_ref, $titles_ref ) = grabData($infile);

    my @dataArray = @$dataArray_ref;
    my @titles = @$titles_ref;
    my $numCol = @titles;

    for ( my $i = 1; $i < $numCol; $i++ ) {
        graphData($titles[0], $titles[$i], $dataArray[0], $dataArray[$i], $xStart[$i-1], $xEnd[$i-1], $yStart[$i-1], $yEnd[$i-1]);
    }

    exit(1); # success
}

sub parseCommand {
    my @xStart;
    my @xEnd;
    my @yStart;
    my @yEnd;
    my $infile;
    Getopt::Long::Configure('bundling_override');
    GetOptions('xs=s' => \@xStart,
               'xe=s' => \@xEnd,
               'ys=s' => \@yStart,
               'ye=s' => \@yEnd,
               'i=s' => \$infile);
    if ($infile eq -1) {
        print "a file must be specified using the -i option; exitted with errors\n";
        exit(-1)
    }
    for (my $i = 0; $i < @xStart; $i++) {
        if ($i < @xEnd && $xStart[$i] ge $xEnd[$i]) {
            print "the x axis start of the graph window must be less then the end; options xStart = $xStart[$i] and xEnd = $xEnd[$i] exitted with errors\n";
            exit(-1);
        }
    }
    for (my $i = 0; $i < @yStart; $i++) {
        if ($i < @yEnd && $yStart[$i] ge $yEnd[$i]) {
            print "the y axis start of the graph window must be less then the end; options yStart = $yStart[$i] and yEnd = $yEnd[$i] exitted with errors \n";
            exit(-1);
        }
    }

    return($infile, \@xStart, \@xEnd, \@yStart, \@yEnd);
}

sub grabData {
    my $infile = shift;
    my @titles;
    my $inc = 0;
    my $numDataC = 0;
    my @dataArray;
    my $units;
    open(FILE, $infile) || die "unable to open $infile for reading; exitted with error:\n$!";
    while (<FILE>) {
        s/^\s+|\s+$//;
        my @splitLine = split(/\s+/, $_);
        if (/xaxis\s+label\s+"(.*)"/) {
            push(@titles, $1);
            $numDataC++;
        } elsif (/yaxis\s+label\s+"(.*)"/) {
            $units = $1;
            $units =~ s/\//\\/g;
        } elsif (/@\s+s[0-9]+\s+legend\s+"(.*)"/) {
            push(@titles, $1 . " " . $units);
            $numDataC++;
        } elsif (/^@|^#/) {
            next;
        } else {
            for ( my $colNum = 0; $colNum < $numDataC; $colNum++ ) {
               $dataArray[$colNum][$inc] = $splitLine[$colNum];
            }
            $inc++;    
        }
    }
    return( \@dataArray, \@titles);
}

sub trimData {
    my ($xAxisData, $yAxisData, $xStart, $xEnd, $yStart, $yEnd) = @_;

    my @xData = @$xAxisData;
    my @yData = @$yAxisData;

    my $xMinVal = min(@xData);
    my $xMaxVal = max(@xData);
    my $yMinVal = min(@yData);
    my $yMaxVal = max(@yData);

    if (defined $xStart && $xStart ne "no") {
        if ($xStart ge $xMaxVal) {
            print "the x axis start of the graph window must be less maximum x value; exitted with errors\n";
            exit(-1);
        }
        for (my $j = 0; $j < @xData; $j++) {
            if ($xData[$j] < $xStart) {
                splice(@xData, $j, 1);
                splice(@yData, $j, 1);
                $j--;
            }
        }
    }
    if (defined $yStart && $yStart ne "no") {
        if ($yStart ge $yMaxVal) {
            print "the y axis start of the graph window must be less maximum y value; exitted with errors\n";
            exit(-1);
        }
        for (my $j = 0; $j < @yData; $j++) {
            if ($yData[$j] < $yStart) {
                splice(@xData, $j, 1);
                splice(@yData, $j, 1);
                $j--;
            }
        }
    }
    if (defined $xEnd && $xEnd ne "no") {
        if ($xEnd le $xMinVal) {
            print "the x axis end of the graph window must be greater than the minimum x value; exitted with errors\n";
            exit(-1);
        }
        for (my $j = 0; $j < @xData; $j++) {
            if ($xData[$j] <= $xEnd) {
                splice(@xData, $j, 1);
                splice(@yData, $j, 1);
                $j--;
            }
        }
    }
    if (defined $yEnd && $yEnd ne "no") {
        if ($yEnd le $yMinVal) {
            print "the y axis end of the graph window must be greater than the minimum y value; exitted with errors\n";
            exit(-1);
        }
        for (my $j = 0; $j < @yData; $j++) {
            if ($yData[$j] > $yEnd) {
                splice(@xData, $j, 1);
                splice(@yData, $j, 1);
                $j--;
            }
        }
    }

    return(\@xData, \@yData);
}

sub graphData {
    my $xTitle = shift;
    my $yTitle = shift;
    my $xAxisData = shift;
    my $yAxisData = shift;
    my ($xStart, $xEnd, $yStart, $yEnd) = @_;
    my $title = $yTitle . " in response to " . $xTitle;
    my ($xDataTrim, $yDataTrim) = trimData( $xAxisData, $yAxisData , $xStart, $xEnd, $yStart, $yEnd);
    my @data = ($xDataTrim, $yDataTrim);
    my $graph = GD::Graph::linespoints -> new( 1040, 540 );

    print "$title mean: " . StatFunc::mean($yAxisData) . "\n";
    print "$title standard deviation: " . StatFunc::sd($yAxisData, "S") . "\n";

    $graph -> set(  
        l_margin => 30,
        r_margin => 30,
        t_margin => 30,
        b_margin => 30,
        x_label => $xTitle ,
        y_label => $yTitle ,
        title   => $title ,
        x_min_value => min(@$xDataTrim) ,
        x_max_value => max(@$xDataTrim) ,
        y_min_value => min(@$yDataTrim) ,
        y_max_value => max(@$yDataTrim) ,
        x_tick_number => 2 ,
        zero_axis => 1,
        transparent => 0 ,
        line_types => [ 1 ] ,
        line_width => 0 , 
        markers => [ 7 ] ,
        marker_size => 2 , 
        dclrs => [ qw( black ) ]
    );

    my $image = $graph -> plot(\@data) || die "failed to produce plot with error:\n$!"; 
    my $fTitle = $title . ".png";
    open(OUT,">$fTitle") || die "unable to open $title for writing with error:\n$!";
    print OUT $image -> png;
    close(OUT);
}