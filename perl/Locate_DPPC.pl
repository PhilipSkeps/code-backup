#!/usr/bin/perl

my @Upper_Bound;
my $frame;
my @Upper_BoundX;
my @Y;
my @X;
print "what dump file should I investigate :   ";
#$FILE = <>;
chop $FILE;
#open (FILE,"/home/pskeps/HomeDir/misc/LAMMPS_Result_Files/$FILE") || die "unable to open $FILE";
open (FILE,"/home/pskeps/HomeDir/misc/LAMMPS_Result_Files/foobar_test.results") || die "unable to open $FILE";
while(<FILE>) {
    if (/ITEM: TIMESTEP/) {
        $frame++;
        $i=0;        
        while ("@COORD" ne '') {
            ($X1,$Y1,$Z1)=splice(@COORD,0,3);
            @COORD_Copy=@COORD;
            while ("@COORD_Copy" ne '') {
                ($X2,$Y2,$Z2)=splice(@COORD_Copy,0,3);
                $distance=&distance_calc($X1,$Y1,$Z1,$X2,$Y2,$Z2);
                if ( $distance >= 1.5 && $distance <= 3.5) {
                    if ($Y2 > $Y1) {
                        push(@Upper_BoundX,$X2);
                        push(@Lower_BoundX,$X1);
                        push(@Upper_Bound,$Y2);
                        push(@Lower_Bound,$Y1);
                    }
                    else {
                        push(@Upper_BoundX,$X1);
                        push(@Lower_BoundX,$X2);
                        push(@Upper_Bound,$Y1);
                        push(@Lower_Bound,$Y2);
                    }
                }
            }
        }
        $length_Y=@Y;
        $length_Upper_Bound=@Upper_Bound;
        for ( $index = 0 ; $index < $length_Y ; $index++ ) {
            for ($z = 0 ; $z < $length_Upper_Bound ; $z++ ) {
                if ( @Y[$index] <= @Upper_Bound[$z] && @Y[$index] >= @Lower_Bound[$z] && @Z[$index] >= 0 && (@X[$index] <= @Upper_BoundX[$z] || @X[$index] <= @Lower_BoundX[$z])) {
                    $pass = 1;
                    push(@Upper_Bound_check,@Upper_Bound[$z]);
                    push(@Lower_Bound_check,@Lower_Bound[$z]);
                    $length_Upper_Bound_check = @Upper_Bound_check;
                    for ($g = 0 ; $g < $length_Upper_Bound_check ; $g++) {
                        if ( @Lower_Bound[$z] == @Upper_Bound_check[$g] || @Upper_Bound[$z] == @Lower_Bound_check[$g]) {
                            $pass = 0
                        }
                    }
                    if ( $pass == 1 ) {
                        $count++;
                    }
                }
            }
            undef(@Upper_Bound_check);
            undef(@Lower_Bound_check);
            if ($count % 2 == 1) {
                push(@UNDER_FLAKE,@ATOM[$index]);
                push(@FRAME_INSTANCE,@FRAME[$index]);
                push(@Y_INSTANCE,@Y[$index]);
            }
            undef($count);
        }
        undef(@FRAME);
        undef(@COORD);
        undef(@COORD_Copy);
        undef(@Upper_Bound);
        undef(@Lower_Bound);
        undef(@Y);
        undef(@ATOM);
    }
    if ($i==1) {
        @split_line=split(/\s+/,$_);
        if (@split_line[2] eq 'F') {
           push(@COORD,@split_line[3],@split_line[4],@split_line[5]);
        }
        if (@split_line[2] ne 'Ar' || @split_line[2] ne "F" || @split_line[2] ne "He" || @split_line[2] ne "Ne") {
            push(@Z,@split_line[5]);
            push(@Y,@split_line[4]);
            push(@X,@split_line[3]);
            push(@ATOM,@split_line[0]);
            push(@FRAME,$frame);
        }
    }
    if (/ITEM: ATOMS id mol element xu yu zu/) {
        $i=1;
    }
}

print "ATOMS UNDER FLAKE:\n";
while ("@UNDER_FLAKE" ne '') {
    $UNDER_FLAKE=shift(@UNDER_FLAKE);
    $Y_INSTANCE=shift(@Y_INSTANCE);
    $FRAME_INSTANCE=shift(@FRAME_INSTANCE);
    print "$FRAME_INSTANCE:  $UNDER_FLAKE  $Y_INSTANCE\n";
}




sub distance_calc {
	my $X1=@_[0];
	my $Y1=@_[1];
	my $Z1=@_[2];
	my $X2=@_[3];
	my $Y2=@_[4];
	my $Z2=@_[5];
	my $distance;
	$distance=sqrt( ( $X2 - $X1 )**2 + ( $Y2 - $Y1 )**2 + ( $Z2 - $Z1 )**2 );
	return($distance);
}

