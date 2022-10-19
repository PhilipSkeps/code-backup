#!/usr/bin/perl

#use strict;
#use warnings;

&main();

sub main {

    open(PDB, "$ARGV[0]") || die "failed to open $ARGV[0] for reading\n";

    my @TempDistanceCoords;
    my $TempStringAtomCode;
    my $i = 1;

    while(<PDB>) {
        if ( /GRPH|GP00/ && $_ !~ /END|TER/) {
            my @split_line = split(/\s+/,$_);
            my $tempstring = substr($_,30,26);
            $tempstring =~ s/^\s+|\s+$//;
            my ($x ,$y ,$z ) = split(/\s+/,$tempstring);
            push(@TempDistanceCoords,$x,$y,$z);
            if ($TempStringAtomCode eq '') {
                $TempStringAtomCode=substr($_,12,4);
            }
            else {
                $TempStringAtomCode=join(' ',$TempStringAtomCode,substr($_,12,4));
            }
			push(@AtomNum, $i);
			$i++;
        }
    }

    $TempStringAtomCode=~s/^\s+|\s+$//;
	my @GRPHAtomList=split(/\s+/,$TempStringAtomCode);

    my ($TempBondsGRPH, $TempPairsGRPH, $TempAnglesGRPH, $TempDihedralsGRPH, $AtomData)  = &grapheneBuild(\@TempDistanceCoords, \@GRPHAtomList, \@AtomNum);
	printITP($TempBondsGRPH, $TempPairsGRPH, $TempAnglesGRPH, $TempDihedralsGRPH, $AtomData, \@GRPHAtomList, \@AtomNum);

	close(PDB);

}

sub indexes {
	my ($regex, @Array) = @_;
	my $i = 0;
	my @ReturnArray;
	map {
		if (/$regex/) {
			push(@ReturnArray, $i);
		}
		$i++;
	} @Array;

	return(@ReturnArray);
}

sub uniq {
	my (@data) = @_;

	my @unique;
    my %seen;
     
    foreach my $value (@data) {
      if (! $seen{$value}) {
        push @unique, $value;
        $seen{$value} = 1;
      }
    }

	return @unique;
}

sub pairUniq {
	my (@array1) = @_;

	my @ReturnArray;

	while ("@array1" ne "") {
		@TestPair = splice(@array1, 0, 2);
		my $pass = 1;
		for (my $i = 0; $i < @array1; $i+=2) {
			if ($TestPair[0] eq $array1[$i] && $TestPair[1] eq $array1[$i+1]) {
				$pass = 0; 
			} elsif ($TestPair[1] eq $array1[$i] && $TestPair[0] eq $array1[$i+1]) {
				$pass = 0;
			}
		}
		if ($pass) {
			push(@ReturnArray,@TestPair);
		}
	}

	return(@ReturnArray);
}

sub angles {

	my $j=0;
	my $length_matching_indices=0;
	my $current_angles_length=0;
	my $TempBondsUniq_ref=@_[0];
	my @TempBondsUniq=@$TempBondsUniq_ref;
	my $TempBondsScattered_ref=@_[1];
	my @TempBondsScattered=@$TempBondsScattered_ref;
	my @TempAngles_build;
	my @TempAngles;
	my @matching_indices;
	my $element;
    my $matching_indice;
    my $length_temp_angles;
    my @TempAngles_splice;
    my @IndividualAngle;
    my @IndividualAngle_sort;
    my @sort_TempAngle_build;
    my $TempAngles_build;
    my $r = 0;
	foreach $element (@TempBondsUniq) {
		@matching_indices=indexes(qr/\b\Q$element\E\b/, @TempBondsScattered);
		#print "@matching_indices\n";
		$length_matching_indices=@matching_indices;
		if ($length_matching_indices > 1) {
			for ($j=0; $j<$length_matching_indices; $j++) {
				if ($matching_indices[$j]%2==0) {
					$TempAngles_build[2]=@TempBondsScattered[(@matching_indices[$j]+1)];
					@TempAngles_build[1]=@TempBondsScattered[(@matching_indices)];
				}
				else {
					$TempAngles_build[2]=@TempBondsScattered[(@matching_indices[$j]-1)];
					@TempAngles_build[1]=@TempBondsScattered[(@matching_indices)];
				}
				foreach $matching_indice (@matching_indices) {
					$length_temp_angles=@TempAngles;
					@TempAngles_splice=@TempAngles;
					if ($matching_indice%2==0 && $TempBondsScattered[$matching_indice+1] ne $TempAngles_build[2]) {
						$TempAngles_build[0]=$TempBondsScattered[$matching_indice+1];
						$r=1;
					}
					elsif ($matching_indice%2==1 && @TempBondsScattered[$matching_indice-1] ne @TempAngles_build[2]) {
						@TempAngles_build[0]=@TempBondsScattered[$matching_indice-1];
						$r=1;
					}
					for (my $h=0; $h<($length_temp_angles/3); $h++ ) {
						@IndividualAngle=splice(@TempAngles_splice,0,3);
						@IndividualAngle_sort=sort(@IndividualAngle);
						@sort_TempAngle_build=sort(@TempAngles_build);
						if ("@IndividualAngle_sort" eq "@sort_TempAngle_build") {
							$r=0;
						}
					}
					if ($r==1) {
						push(@TempAngles,@TempAngles_build);
					}
					$r=0;
				}
			}
		}
	}
	return @TempAngles;
}

sub dihedrals {

    my @TempDihedrals_ordered;
	my $length_matching_indices=0;
	my $current_dihedral_length=0;
	my $length_temp_dihedrals=0;
	my $TempBondsUniq_ref=@_[0];
	my @TempBondsUniq=@$TempBondsUniq_ref;
	my $TempBondsScattered_ref=@_[1];
	my @TempBondsScattered=@$TempBondsScattered_ref;
	my @TempDihedrals;
	my @TempDihedrals_capture;
	my @next_element_check;
	my $length_next_element_check=0;
	my @IndividualDihedral;
	my @TempDihedrals_splice;
	my $w=0;
	my $r=1;
	my $element;
	my @matching_indices;
	my $i=0;
    my $f = 0;
	foreach $element (@TempBondsUniq) {
		@matching_indices=indexes(qr/\b\Q$element\E\b/, @TempBondsScattered);
		#print "@matching_indices\n";
		$length_matching_indices=@matching_indices;
		if ($length_matching_indices > 2) {
			for ($i=0; $i<$length_matching_indices; $i++) {
				$current_dihedral_length=@TempDihedrals;
				if (@matching_indices[$i]%2==0){
					@next_element_check=indexes(qr/\b\Q@TempBondsScattered[(@matching_indices[$i]+1)]\E\b/, @TempBondsScattered);
				}
				else {
					@next_element_check=indexes(qr/\b\Q@TempBondsScattered[(@matching_indices[$i]-1)]\E\b/, @TempBondsScattered);
				}
				#print "@next_element_check\n";
				$length_next_element_check=@next_element_check;
				if ($length_next_element_check > 1) {
					if (@matching_indices[$i]%2==0) {
						@TempDihedrals_capture[1]=@TempBondsScattered[(@matching_indices[$i])];
						@TempDihedrals_capture[2]=@TempBondsScattered[(@matching_indices[$i]+1)];
					}
					else {
						@TempDihedrals_capture[1]=@TempBondsScattered[(@matching_indices[$i])];
						@TempDihedrals_capture[2]=@TempBondsScattered[(@matching_indices[$i]-1)];
					}
					for (my $j=0; $j < $length_matching_indices; $j++) {
						if (@matching_indices[$j]%2==0 && @TempBondsScattered[@matching_indices[$j]+1] ne @TempDihedrals_capture[2]) {
							@TempDihedrals_capture[0]=@TempBondsScattered[(@matching_indices[$j]+1)];
							$f=1;
						}
						elsif (@matching_indices[$j]%2==1 && @TempBondsScattered[@matching_indices[$j]-1] ne @TempDihedrals_capture[2]) {
							@TempDihedrals_capture[0]=@TempBondsScattered[@matching_indices[$j]-1];
							$f=1;
						}
						if ($f==1) {
							#print "@next_element_check\n";
							for (my $h=0; $h < $length_next_element_check; $h++) {
								if (@next_element_check[$h]%2==0 && @TempBondsScattered[@next_element_check[$h]+1] ne @TempDihedrals_capture[1]) {
									#print "@next_element_check[$h] is even\n";
									@TempDihedrals_capture[3]=@TempBondsScattered[(@next_element_check[$h]+1)];
									$length_temp_dihedrals=@TempDihedrals;
									@TempDihedrals_splice=@TempDihedrals;
									@TempDihedrals_ordered=@TempDihedrals_capture;
									for($w=0; $w<($length_temp_dihedrals/4); $w++) {
										@IndividualDihedral=splice(@TempDihedrals_splice,0,4);
										@IndividualDihedral=sort(@IndividualDihedral);
										@TempDihedrals_ordered=sort(@TempDihedrals_ordered);
										if ("@TempDihedrals_ordered" eq "@IndividualDihedral") {
											#print "@TempDihedrals_capture\n\n";
											$r=0;
										}
									}
									if ($r==1) {
										push(@TempDihedrals,@TempDihedrals_capture[0],@TempDihedrals_capture[1],@TempDihedrals_capture[2],@TempDihedrals_capture[3]);
									}
									$r=1;							
								}
								elsif (@next_element_check[$h]%2==1 && @TempBondsScattered[@next_element_check[$h]-1] ne @TempDihedrals_capture[1]) {
									#print "@next_element_check[$h] is odd\n";
									@TempDihedrals_capture[3]=@TempBondsScattered[(@next_element_check[$h]-1)];
									$length_temp_dihedrals=@TempDihedrals;
									@TempDihedrals_splice=@TempDihedrals;
									@TempDihedrals_ordered=@TempDihedrals_capture;
									for($w=0; $w<($length_temp_dihedrals/4); $w++) {
										@IndividualDihedral=splice(@TempDihedrals_splice,0,4);
										@IndividualDihedral=sort(@IndividualDihedral);
										@TempDihedrals_ordered=sort(@TempDihedrals_ordered);
										if ("@TempDihedrals_ordered" eq "@IndividualDihedral") {
											#print "@TempDihedrals_capture\n\n";
											$r=0;
										}
									}
									if ($r==1) {
										push(@TempDihedrals,@TempDihedrals_capture[0],@TempDihedrals_capture[1],@TempDihedrals_capture[2],@TempDihedrals_capture[3]);
									}
									$r=1;	
								}
							}
						}
						$f=0;
					}
				}
			}	
		}
	}
	return @TempDihedrals
}

sub pairs {
    my ($Dihedrals) = @_;
	my @DihedralArr = @$Dihedrals;
	my @PairsNonUniq;

	for(my $i = 0; $i < @DihedralArr; $i+=4) {
		push(@PairsNonUniq, @DihedralArr[$i],@DihedralArr[$i+3]);
	}

	my @Pairs = pairUniq(@PairsNonUniq);

	return(@Pairs);

}

sub distanceCalc {

	my ($X1, $Y1, $Z1, $X2, $Y2, $Z2) = @_;
	my $distance = sqrt( ( $X2 - $X1 ) ** 2 + ( $Y2 - $Y1 ) ** 2 + ( $Z2 - $Z1 ) ** 2 );
	
    return($distance);

}

sub grapheneBuild {
	
    # open(LOGFILE,">distance.log") || die "unable to open logfile";
	my ($TempDistanceCoords, $GRPHAtomID, $AtomNumRef) = @_;
    my @TempBondsGRPH;
    my %AtomData;

	my $i = 0;

	foreach (@$GRPHAtomID) {
		if ($_=~/C/) {
			$AtomData{$_} = 'CG2R61';
		}
		else {
			$AtomData{$_} = 'HGR61';
		}
	}

	my @AtomNum = @$AtomNumRef;

	while ("@$TempDistanceCoords" ne '') {
		my $AtomNumEle = shift(@AtomNum);
		my ($X1,$Y1,$Z1) = splice(@$TempDistanceCoords,0,3);
		my @AtomNumCopy = @AtomNum;
		my @TempDistanceCoordsCopy = @$TempDistanceCoords;
		while ("@TempDistanceCoordsCopy" ne '') {
			my $AtomNumCopyEle = shift(@AtomNumCopy);
			my ($X2,$Y2,$Z2) = splice(@TempDistanceCoordsCopy,0,3);
			my $distance = &distanceCalc($X1,$Y1,$Z1,$X2,$Y2,$Z2);
			if ( ($distance >= 1.24 && $distance <= 1.57) || ($distance >= 0.70 && $distance <= 1.24)) {
				push(@TempBondsGRPH, $AtomNumEle, $AtomNumCopyEle);
			}
			else {
				# print LOGFILE "$distance   $AtomNumEle   $AtomNumCopyEle\n";
			}
		}
	}

	my @TempBondsUniq=uniq(@TempBondsGRPH);
	my @TempAnglesGRPH=&angles(\@TempBondsUniq,\@TempBondsGRPH);
	my @TempDihedralsGRPH=&dihedrals(\@TempBondsUniq,\@TempBondsGRPH);
    my @TempPairsGRPH=&pairs(\@TempDihedralsGRPH);

    return(\@TempBondsGRPH, \@TempPairsGRPH, \@TempAnglesGRPH, \@TempDihedralsGRPH, \%AtomData);
}

sub printITP {

    my ($TempBondsGRPH, $TempPairsGRPH, $TempAnglesGRPH, $TempDihedralsGRPH, $AtomData, $GRPHAtomList, $AtomNum) = @_;

    my %MassData = ( CG2R61 => "12.0110", HGR61 => "1.0080" );

    my @GRPHAtomListArr = @$GRPHAtomList; # GRPHAtomListArr = 0 this is wrong
    my %AtomDataMap = %$AtomData;

    open(OUT, ">NMA.itp") || die "Unable to open NMA\n";
    print OUT ";;\n;; Generated by Me\n;;\n;; Correspondance:\n;; jul316@lehigh.edu or wonpil@lehigh.edu\n;;\n;; GROMACS topology file for NMA\n;;\n\n\n";
    print OUT "[ moleculetype ]\n; name  nrexcl\nNMA          3\n\n";
    print OUT "[ atoms ]\n; nr    type    resnr   residu  atom    cgnr    charge  mass\n";
    for(my $i = 0; $i < @GRPHAtomListArr; $i++) {
        my $AtomCode = $AtomDataMap{$GRPHAtomListArr[$i]};
        printf OUT ("%6s%11s%7s%9s%7s%7s     0.000000%11s   ; qtot  0.000\n", $i + 1, $AtomCode, 1, GP001, $GRPHAtomListArr[$i], $i + 1, $MassData{$AtomCode});  
    }

    my @TempBondsGRPHArr = @$TempBondsGRPH;

    print OUT "\n[ bonds ]\n; ai    aj      funct   b0      Kb\n";
    for(my $i = 0; $i < @TempBondsGRPHArr; $i+=2) {
        printf OUT ("%5s%6s     1\n", $TempBondsGRPHArr[$i], $TempBondsGRPHArr[$i + 1]);
    }

    my @TempPairsGRPHArr = @$TempPairsGRPH;

    print OUT "\n[ pairs ]\n; ai    aj      funct   c6      c12 or\n; ai    aj      funct   fudgeQQ q1      q2      c6      c12\n";
    for(my $i = 0; $i < @TempPairsGRPHArr; $i+=2) {
        printf OUT ("%5s%6s     1\n", $TempPairsGRPHArr[$i], $TempPairsGRPHArr[$i + 1]);
    }

    my @TempAnglesGRPHArr = @$TempAnglesGRPH;

    print OUT "\n[ angles ]\n; ai    aj      ak      funct   th0     cth     S0      Kub\n";
    for(my $i = 0; $i < @TempAnglesGRPHArr; $i+=3) {
        printf OUT ("%5s%6s%6s     5\n", $TempAnglesGRPHArr[$i], $TempAnglesGRPHArr[$i + 1], $TempAnglesGRPHArr[$i + 2]);
    }

    my @TempDihedralsGRPHArr = @$TempDihedralsGRPH;

    print OUT "\n[ dihedrals ]\n; ai    aj      ak      al      funct   phi0    cp      mult\n";
    for(my $i = 0; $i < @TempDihedralsGRPHArr; $i+=4) {
        printf OUT ("%5s%6s%6s%6s     9\n", $TempDihedralsGRPHArr[$i], $TempDihedralsGRPHArr[$i + 1], $TempDihedralsGRPHArr[$i + 2], $TempDihedralsGRPHArr[$i + 3]);
    }

	my @AtomNumArr = @AtomNum;

	print OUT "\n#ifdef POSRES\n[ position_restraints ]\n";
	map {
		if ($GRPHAtomListArr[$_ - 1] =~ /C/) {
			printf OUT ("%5s%6s    POSRES_FC_BB    POSRES_FC_BB    POSRES_FC_BB\n", $_, 1);
		}
	} @AtomNumArr;
	print OUT "#endif";
    
}