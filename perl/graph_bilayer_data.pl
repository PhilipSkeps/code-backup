#!/usr/bin/perl

use CGI ':standard';
use GD::Graph::lines;
use List::Util qw(sum);

$NoL=64;

sub mean {
    $array=shift;
    @array=@$array;
    $average=(sum(@array)/(@array));
    return $average;
}


open(WFILE,"/home/philip/HomeDir/misc/LAMMPS_Result_Files/expdataw.sim") || die "unable to open the wfile";
while (<WFILE>) {
    @split_line=split(/\s+/,$_);
    if ( @split_line[0] >= 2200000 ) {
        $volumepw=(@split_line[1]/5000000);
        push(@volumepw,$volumepw);   
    }
}

$avolumepw=&mean(\@volumepw);
$Vw = $avolumepw;

open(FILE,"/home/philip/HomeDir/misc/LAMMPS_Result_Files/expdata.sim") || die "unable to open the file";
while (<FILE>) {
    @split_line=split(/\s+/,$_);
    $volumepL=(((@split_line[1]/1000)-(1871*$Vw))/($NoL));
    $z_L=(@split_line[2]/10);
    $areapL=(2*@split_line[3])/(100*$NoL);
    push(@volumepL,$volumepL);
    push(@z_L,$z_L);
    push(@areapL,$areapL);
    push(@TimeStamp,@split_line[0]);
}




close(FILE);
my @data1 = (\@TimeStamp, \@volumepL);
my @data2 = (\@TimeStamp, \@areapL); 
my @data3 = (\@TimeStamp, \@z_L);
my $graph1 = GD::Graph::lines->new(600,300);
my $graph2 = GD::Graph::lines->new(600,300);
my $graph3 = GD::Graph::lines->new(600,300);
$graph1->set(  
    x_label => 'TimeStep (fs)' ,
    y_label => 'nm^3',
    title   => 'Volume per Lipid Over Time',
    line_types => 1,
    line_width => 1,
    y_min_value => 1.2,
    y_max_value => 1.3,
    x_tick_number => 2,
    transparent => 0,
    x_min_value => 0,
    x_max_value => 5300000,
);
$graph2->set(
   x_label => 'TimeStep (fs)',
    y_label => 'nm^2',
    title   => 'Area per Lipid Over Time',
    line_types => 1,
    line_width => 1,
    y_min_value => 0.58,
    y_max_value => 0.70,
    x_tick_number => 2,
    transparent => 0,
    x_min_value => 0,
    x_max_value => 5300000,
);
$graph3->set(
    x_label => 'TimeStep (fs)',
    y_label => 'nm',
    title   => 'Height of the Tank Over Time',
    line_types => 1,
    line_width => 1,
    y_min_value => 6.22,
    y_max_value => 6.5,
    x_tick_number => 2,
    transparent => 0,
    x_min_value => 0,
    x_max_value => 5300000,
);

my $image1 = $graph1->plot(\@data1) || die 'fuck this shit';
my $image2 = $graph2->plot(\@data2) || die 'unable to build graph2';
my $image3 = $graph3->plot(\@data3) || die 'unable to build graph3';

#print $image1->png;
print $image2->png;
#print $image3->png;