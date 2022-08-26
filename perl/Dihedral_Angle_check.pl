#!/usr/bin/perl

use List::Uniq ':all';
use List::MoreUtils qw(first_index indexes);


sub dihedrals {
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
	foreach $element (@TempBondsUniq) {
		@matching_indices=indexes { /\b\Q$element\E\b/ } @TempBondsScattered;
		#print "@matching_indices\n";
		$length_matching_indices=@matching_indices;
		if ($length_matching_indices > 0) {
			for ($i=0; $i<$length_matching_indices; $i++) {
				$current_dihedral_length=@TempDihedrals;
				if (@matching_indices[$i]%2==0){
					@next_element_check=indexes { /\b\Q@TempBondsScattered[(@matching_indices[$i]+1)]\E\b/ } @TempBondsScattered;
				}
				else {
					@next_element_check=indexes { /\b\Q@TempBondsScattered[(@matching_indices[$i]-1)]\E\b/ } @TempBondsScattered;
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
					for ($j=0; $j < $length_matching_indices; $j++) {
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
							for ($h=0; $h < $length_next_element_check; $h++) {
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
									$r=1							
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
									$r=1	
								}
							}
						}
						$f=0
					}
				}
			}	
		}
	}
	return @TempDihedrals
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
	foreach $element (@TempBondsUniq) {
		@matching_indices=indexes { /\b\Q$element\E\b/ } @TempBondsScattered;
		#print "@matching_indices\n";
		$length_matching_indices=@matching_indices;
		if ($length_matching_indices > 1) {
			for ($j=0; $j<$length_matching_indices; $j++) {
				if (@matching_indices[$j]%2==0) {
					@TempAngles_build[2]=@TempBondsScattered[(@matching_indices[$j]+1)];
					@TempAngles_build[1]=@TempBondsScattered[(@matching_indices)];
				}
				else {
					@TempAngles_build[2]=@TempBondsScattered[(@matching_indices[$j]-1)];
					@TempAngles_build[1]=@TempBondsScattered[(@matching_indices)];
				}
				foreach $matching_indice (@matching_indices) {
					$length_temp_angles=@TempAngles;
					@TempAngles_splice=@TempAngles;
					if ($matching_indice%2==0 && @TempBondsScattered[$matching_indice+1] ne @TempAngles_build[2]) {
						@TempAngles_build[0]=@TempBondsScattered[$matching_indice+1];
						$r=1;
					}
					elsif ($matching_indice%2==1 && @TempBondsScattered[$matching_indice-1] ne @TempAngles_build[2]) {
						@TempAngles_build[0]=@TempBondsScattered[$matching_indice-1];
						$r=1;
					}
					for ($h=0; $h<($length_temp_angles/3); $h++ ) {
						@IndividualAngle=splice(@TempAngles_splice,0,3);
						@IndividualAngle_sort=sort(@IndividualAngle);
						@sort_TempAngle_build=sort(@TempAngles_build);
						if ("@IndividualAngle_sort" eq "@sort_TempAngle_build") {
							$r=0
						}
					}
					if ($r==1) {
						push(@TempAngles,@TempAngles_build);
					}
					$r=0
				}
			}
		}
	}
	return @TempAngles	
}

my @Split_DPPCLINE;
my $i;
my $d;
my $g;
my %DataStringCreater;
my %DataTypeCreater;
my %ChargeCreater;
my %MassCreater;
my @Atom_Code_DPPC;
my @PreBond;
my @PreAngle;
my @PreDihedral;
my @PreImproper;
my @TempBonds;
my @TempAngles;
my @TempDihedrals;
my @TempImpropers;
open(DPPCFILE,'/home/philip/Documents/dppc.itp') || die "unable to open dppc.itp";
while(<DPPCFILE>) {
    if (/\s+DPPC\s+/) {
        $_ =~ s/^\s+|\s+$//;
        @Split_DPPCLINE=split(/\s+/,$_);
        $DataStringCreater{@Split_DPPCLINE[0]} = @Split_DPPCLINE[4];
        $DataTypeCreater{@Split_DPPCLINE[4]} = @Split_DPPCLINE[1];
        $ChargeCreater{@Split_DPPCLINE[4]} = @Split_DPPCLINE[6];
        $MassCreater{@Split_DPPCLINE[1]} = @Split_DPPCLINE[7];
        push(@Atom_Code_DPPC,@Split_DPPCLINE[0]);
    }
    if (/\[ bonds \]/) {
        $i=1;
    }
    if (/^\n$/) {
        $i=0;
    }
    if ($i==1 && /^\s+/) {
        $_ =~ s/^\s+|\s+$//;
        @Split_DPPCLINE=split(/\s+/,$_);
        push(@PreBond,@Split_DPPCLINE[0],@Split_DPPCLINE[1]);
    }
    if (/\[ angles \]/) {
        $d=1;
    }
    if (/^\n$/) {
        $d=0;
    }
    if ($d==1 && /^\s+/) {
        $_ =~ s/^\s+|\s+$//;
        @Split_DPPCLINE=split(/\s+/,$_);
        push(@PreAngle,@Split_DPPCLINE[0],@Split_DPPCLINE[1],@Split_DPPCLINE[2]);
    }
    if (/\[ dihedrals \]/) {
        $g=1;
    }
    if (/^\n$/) {
        $g=0;
    }
    if ($g==1) {
        $_ =~ s/^\s+|\s+$//;
        @Split_DPPCLINE=split(/\s+/,$_);
        if (@Split_DPPCLINE[4]==1 || @Split_DPPCLINE[4]==3) {
            push(@PreDihedral,@Split_DPPCLINE[0],@Split_DPPCLINE[1],@Split_DPPCLINE[2],@Split_DPPCLINE[3]);
            $dihedral_numbers_string="@Split_DPPCLINE[5] @Split_DPPCLINE[6] @Split_DPPCLINE[7]";
            $dihedral_string="@Split_DPPCLINE[0] @Split_DPPCLINE[1] @Split_DPPCLINE[2] @Split_DPPCLINE[3]";
            map { $dihedral_string=~s/$_/$DataStringCreater{$_}/ } @Atom_Code_DPPC;
            $Assoc_Dihedral_Num{$dihedral_numbers_string}=$dihedral_string;
            push(@DPPCDihedralType,@Split_DPPCLINE[5]);
            push(@Dihedral_Numbered,$dihedral_string);
        }
        if (@Split_DPPCLINE[4]==2) {
            push(@PreImproper,@Split_DPPCLINE[0],@Split_DPPCLINE[1],@Split_DPPCLINE[2],@Split_DPPCLINE[3])
        }
    }
}
map { push(@TempBonds,$DataStringCreater{$_}) } @PreBond;
@TempBonds_uniq=uniq(@TempBonds);
@angles=angles(\@TempBonds_uniq,\@TempBonds);
@dihedrals=dihedrals(\@TempBonds_uniq,\@TempBonds);

my $TempStringAngles="@angles";
my $TempStringDihedrals="@dihedrals";
foreach $Atom (@TempBonds_uniq) { #should not be boobs check spelling
	$count+=1;
	$TempStringAngles=~s/\b\Q$Atom\E\b/$count/g;
	$TempStringDihedrals=~s/\b\Q$Atom\E\b/$count/g;
}	

@TempAnglesNumbered=split(/\s+/,$TempStringAngles);
@TempDihedralsNumbered=split(/\s+/,$TempStringDihedrals);


$temp_length_angles = @TempAnglesNumbered;
$length_angles = $temp_length_angles/3;
print "$length_angles\n";
while( "@TempAnglesNumbered" ne '' ) {
	@print_angle=splice(@TempAnglesNumbered,0,3);
	print "@print_angle\n";
}

$temp_length_dihedrals = @TempDihedralsNumbered;
$length_dihedrals = $temp_length_dihedrals/4;
print "$length_dihedrals\n";
while( "@TempDihedralsNumbered" ne '' ) {
	@print_dihedral=splice(@TempDihedralsNumbered,0,4);
	print "@print_dihedral\n";
}