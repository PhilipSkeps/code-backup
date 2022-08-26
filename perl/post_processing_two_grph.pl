#!/usr/bin/perl

use Array::Average;

print "give a result file to process\n";
$myrfile=<>;
chop $myrfile;
open(RFILE,"/home/philip/HomeDir/misc/LAMMPS_Result_Files/$myrfile") || die "unable to open $myrfile";
$myrfile=~s/\.results//;
$mydir=$myrfile;
$mypfile=$myrfile . ".pdb";
$mywfile=$myrfile . ".pp";
mkdir("/home/philip/HomeDir/misc/Post_Processed_LAMMPS/$mydir");
chdir("/home/philip/HomeDir/misc/Post_Processed_LAMMPS/$mydir") || die "unable to change dir to $mydir";
open(OUT,">$mywfile") || die "unable to write to /home/philip/HomeDir/misc/Post_Processed_LAMMPS/$mydir/$mywfile";
open(PFILE,"/home/philip/HomeDir/misc/PDB_Files/2Graphene_Water_5rings.pdb") || die "unable to open /home/philip/HomeDir/misc/PDB_Files/$mypfile";
my @COORDINATES;
while(<PFILE>) {
    $G_ID_new = $1 if ($_ =~ /\sGRPH([A-Z])\s/);
    if (/GRPH/) {
        $A_ID = $1 if ($_ =~ /^HETATM([0-9]*)\s/);
    }
    if( ($G_ID_new ne $G_ID_old && $G_ID_old ne '') || $_=~/^END/ ) {
        push(@G_ID,$G_ID_old);
        $last_element=pop(@A_ID);
        push(@A_ID_range,@A_ID[0],$last_element);
        undef(@A_ID);
    }
    if (/GRPH/) {
        push(@A_ID,$A_ID);
    }
    $G_ID_old=$G_ID_new;
}
$len_A_ID_range=@A_ID_range;
while(<RFILE>) {
    if (/^ITEM: ATOMS/) {
        $frames++;
    }
}
$reset=$/;
$/='ITEM: TIMESTEP';
while("@A_ID_range" ne '') {
    $count++;
    $low_bound=shift(@A_ID_range);
    $upper_bound=shift(@A_ID_range);
    seek( RFILE , 0, 0 ) || die "unable to return result file to the beginning";
    while(<RFILE>) {
        $gain++;
        $percent_done=(($gain/($len_A_ID_range*$frames))*100);
        print "$percent_done\n";
        foreach $id ($low_bound .. $upper_bound) {
            $string= $1 if (/\n($id.*)\n/);
            @split_string=split(/\s+/,$string);
            push(@X,@split_string[3]);
            push(@Y,@split_string[4]);
            push(@Z,@split_string[5]);
        }
        foreach $dummy (@X) {
            $X1=shift(@X);
            $Y1=shift(@Y);
            $Z1=shift(@Z);
            @X_temp=@X;
            @Y_temp=@Y;
            @Z_temp=@Z;
            foreach $dummy0 (@X_temp) {
                $X2=shift(@X_temp);
                $Y2=shift(@Y_temp);
                $Z2=shift(@Z_temp);
                $new_distance=&distance($X1,$Y1,$Z1,$X2,$Y2,$Z2);
            }
            ($X_keep1,$Y_keep1,$Z_keep1,$X_keep2,$Y_keep2,$Z_keep2,$kept_distance)=&max_distance($new_distance,$kept_distance,$X1,$Y1,$Z1,$X2,$Y2,$Z2);
        }
        push(@X_far,$X_keep1,$X_keep2);
        push(@Y_far,$Y_keep1,$Y_keep2);
        push(@Z_far,$Z_keep1,$Z_keep2);
        $CENTERX=average(@X_far);
        $CENTERY=average(@Y_far);
        $CENTERZ=average(@Z_far);
        undef(@X_far);
        undef(@Y_far);
        undef(@Z_far);
        undef(@X);
        undef(@Y);
        undef(@Z);
        undef($kept_distance);
        if ($CENTERX ne '') {
            push(@COORDINATES,$CENTERX,$CENTERY,$CENTERZ);
        }
    }
}
$/=$reset;
&write_file(\@COORDINATES,\@G_ID,*OUT,$frames,$count);



sub distance {
    my $X1=@_[0];
	my $Y1=@_[1];
	my $Z1=@_[2];
	my $X2=@_[3];
	my $Y2=@_[4];
	my $Z2=@_[5];
    my $distance;
	$distance=sqrt( ( $X2 - $X1 )**2 + ( $Y2 - $Y1 )**2 + ( $Z2 - $Z1 )**2 );
	return($distance)
}


sub max_distance {
    my $new_distance=shift;
    my $kept_distance=shift;
    my $X1=shift;
    my $Y1=shift;
    my $Z1=shift;
    my $X2=shift;
    my $Y2=shift;
    my $Z2=shift;
    if ( $new_distance >= $kept_distance ) {
        $X_keep1=$X1;
        $Y_keep1=$Y1;
        $Z_keep1=$Z1;
        $X_keep2=$X2;
        $Y_keep2=$Y2;
        $Z_keep2=$Z2;
        $kept_distance=$new_distance;
    }
    return($X_keep1,$Y_keep1,$Z_keep1,$X_keep2,$Y_keep2,$Z_keep2,$kept_distance);
}


sub write_file {
    my $i=0;
    my $g=0;
    my $COORDINATES_ref=shift;
    my $G_ID_ref=shift;
    my @COORDINATES=@$COORDINATES_ref;
    my @G_ID=@$G_ID_ref;
    $out=shift;
    my $frames=shift;
    my $count=shift;
    $len_COORDINATES=@COORDINATES;
    print "$len_COORDINATES\n";
    for($i=0; $i < $frames; $i++) {
        print $out "Frame: $i\n";
        for($g=0; $g < $count; $g++) {
            ($X_c,$Y_c,$Z_c)=splice(@COORDINATES,$g*$frames,3);
            print $out "Sheet @G_ID[$g]: $X_c $Y_c $Z_c\n";
        }
    }
}