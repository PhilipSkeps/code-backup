#!/usr/bin/perl


use File::Spec;
use List::Uniq ':all';
use List::MoreUtils qw(first_index indexes);
use List::Util qw(max min);
use Cwd qw(cwd);
&LAMMPS_data_file_builder;



sub build_from_pdb {
    chdir('/home/philip/HomeDir/misc/PDB_Files') || die "could not change directory to PDB_Files";
	my @X=();
	my @Y=();
	my @Z=();
	my $TEMPFILE;
	my $coordstring;
	my $tempstring;
	my $x_temp;
	my $x;
	my $y;
	my $y_temp;
	my $z;
    my $TempStringAtomCode;
	my $atomtype_numbered;
	my $bondtype_numbered;
	my $angletype_numbered;
	my $dihedraltype_numbered;
	my $impropertype_numbered;
	my $atomcharge;
	my $bonds;
	my $angles;
	my $dihedrals;
	my $impropers;
	my @ATOMTYPE_NUMBERED;
	my @BONDTYPE_NUMBERED;
	my @ANGLETYPE_NUMBERED;
	my @DIHEDRALTYPE_NUMBERED;
	my @IMPROPERTYPE_NUMBERED;
	my @ATOMCHARGE;
	my @BONDS;
	my @ANGLES;
	my @DIHEDRALS;
	my @IMPROPERS;
	my @TOTAL_ATOMS;
	my @TOTAL_BONDS;
	my @TOTAL_ANGLES;
	my @TOTAL_DIHEDRALS;
	my @TOTAL_IMPROPERS;
	my @COUNT_ATOMS;
	my @COUNT_BONDS;
	my @COUNT_ANGLES;
	my @COUNT_DIHEDRALS;
	my @COUNT_IMPROPERS;
	my @MOLECULETYPE_NUMBERED;
	my @ATOM_MASSES;
	my $AtomMassCodeTotal_ref;
	my $TempBonds_ref;
	my $TesmpAngles_ref;
	my $TempDihedrals_ref;
	my $TempImpropers_ref;
	my $ChargeData_ref;
	my $AtomData_ref;
	my $TempAtomMassCode_ref;
	my $TempBondsNumbered_ref;
	my $TempAnglesNumbered_ref;
	my $TempDihedralsNumbered_ref;
	my $TempImpropersNumbered_ref;
	my $TempBondType_ref;
	my $TempAngleType_ref;
	my $TempDihedralType_ref;
	my $TempImproperType_ref;
    my $resi_id_new;
    my $resi_id_old;
    my $MoleculeNewLine;
    my $MoleculeOldLine;
    my $last_line=0;
    my $switch;
	my $ChargeData_ref;
	my $AtomData_ref;
	my $count;
	my $atom_masses;
	my $resi_id_all;
	my $resi_id_uniq;
	my @Temp_Distance_Coords;
	my $d;
	my $temp_GRPH_Atom_id;
	my @GRPH_Atom_id;
	my @split_PDBLINE;
	my $temp_GRPH_Atom_code;
	my @GRPH_Atom_Code;
	my $MoleculeCodeNew;
	my $MoleculeCodeOld;
	my $length_IMPROPERS;
	my $length_DIHEDRALS;
	my $length_ANGLES;
	my $length_BONDS;
	my $TempBonds_GRPH_ref;
	my $TempAngles_GRPH_ref;
	my $TempDihedrals_GRPH_ref;
	my $GRPH_Charge;
	my $bonddata;
	my $Dihedral_Numbered_Uniq_ref;
	my $Dihedral_Numbered_ref;
	my $atom_mass_code;
	my @TempBondType;
	my @TempAngleType;
	my @TempDihedralType;
	my @TempImproperType;
	my @TempDihedralTypePre;
	my @TempBondTypePre;
	my @TempAngleTypePre;
	my @TempImproperTypePre;
	print "give a pdb file you would like to build a LAMMPS input file for\n";
	$TEMPFILE=<>;
	chop $TEMPFILE;
	open (FILE, $TEMPFILE) or die "Could not open the pdb file";
	$totallines++ while (<FILE>);
	close FILE;
	open(PDBFILE,$TEMPFILE) || die "could not open the pdb file";
	while (<PDBFILE>) {
        $PDBLINE=$_;
		if ($PDBLINE =~ /^HETATM/ || /^ATOM/ || /^TER/ || /^HELIX/ || /^SHEET/ || /^SSBOND/ || /^END/) {
            if ($PDBLINE =~ /^[^END]/){
                ($tempstring)=substr($PDBLINE,30,26);
                $tempstring=~s/^\s+|\s+$//;
                ($x,$y,$z)=split(/\s+/, $tempstring);
                push(@X,$x);
                push(@Y,$y);
                push(@Z,$z);
				push(@resi_id_all,substr($PDBLINE,17,4));
            }
			$MoleculeCodeNew=substr($PDBLINE,21,1);
            $MoleculeNewLine=substr($PDBLINE,23,3);
            if (($MoleculeNewLine ne $MoleculeOldLine && $MoleculeOldLine ne '') || $PDBLINE =~/^END/ || ($MoleculeCodeNew ne $MoleculeCodeOld && $MoleculeCodeOld ne '')) {
				$increase++;
				$percentdone=(($increase/$totallines)*100);
				print "percent done: $percentdone\n";
				if ("@Temp_Distance_Coords" ne '') {
					#print "what graphene file was used as input to the original pdb\n";
					#$CHARGEFILE=<>;
					$GRPH_Charge=&graphene_charge($CHARGEFILE,\@GRPH_Atom_Code);
				}
				push(@TempBondType,@TempBondTypePre);
				push(@TempAngleType,@TempAngleTypePre);
				push(@TempDihedralType,@TempDihedralTypePre);
				push(@TempImproperType,@TempImproperTypePre);
				($TempBonds_GRPH_ref,$TempAngles_GRPH_ref,$TempDihedrals_GRPH_ref)=&graphene_build(\@Temp_Distance_Coords,\@GRPH_Atom_id,\@GRPH_Atom_Code);
				($TempBondType_ref,$TempAngleType_ref,$TempDihedralType_ref,$TempImproperType_ref,$TempAtomMassCode_ref,$atomcharge)=&build_data($ChargeData_ref,$AtomData_ref,$TempStringAtomCode,$TempBonds_ref,$TempAngles_ref,$TempDihedrals_ref,$TempImpropers_ref,\@GRPH_Atom_Code,$TempBonds_GRPH_ref,$TempAngles_GRPH_ref,$TempDihedrals_GRPH_ref,$Offset,$GRPH_Charge,$resi_id_old);
				($AtomMassCodeTotal_ref)=&atom_mass_code($TempAtomMassCode_ref);
				($TempBondsNumbered_ref,$TempAnglesNumbered_ref,$TempDihedralsNumbered_ref,$TempImpropersNumbered_ref)=&number($TempStringAtomCode,$TempBonds_ref,$TempAngles_ref,$TempDihedrals_ref,$TempImpropers_ref,$TempBonds_GRPH_ref,$TempAngles_GRPH_ref,$TempDihedrals_GRPH_ref);
				($bonds,$angles,$dihedrals,$impropers)=&build($TempBondsNumbered_ref,$TempAnglesNumbered_ref,$TempDihedralsNumbered_ref,$TempImpropersNumbered_ref);
				@ATOMCHARGE=@$atomcharge;
				@BONDS=@$bonds;
				@ANGLES=@$angles;
				@DIHEDRALS=@$dihedrals;
				@IMPROPERS=@$impropers;
                $TempStringAtomCode='';
				undef(@Temp_Distance_Coords);
				undef(@GRPH_Atom_id);
				undef(@GRPH_Atom_Code);
				undef($GRPH_Charge);
				undef($Dihedral_Numbered_ref);
                if ($PDBLINE =~ /^END/) {
					($atomtype_numbered,$atom_masses,$atom_mass_code)=&atom_mass_code_numbered($AtomMassCodeTotal_ref);
					($bondtype_numbered,$angletype_numbered,$dihedraltype_numbered,$impropertype_numbered,$TempAngleType_uniq,$TempDihedralType_uniq)=&data_type_numbered(\@TempBondType,\@TempAngleType,\@TempDihedralType,\@TempImproperType);
					@BONDTYPE_NUMBERED=@$bondtype_numbered;
					@ANGLETYPE_NUMBERED=@$angletype_numbered;
					@DIHEDRALTYPE_NUMBERED=@$dihedraltype_numbered;
					@IMPROPERTYPE_NUMBERED=@$impropertype_numbered;
					@ATOM_MASSES=@$atom_masses;
					@ATOMTYPE_NUMBERED=@$atomtype_numbered;
					@resi_id_uniq=uniq(@resi_id_all);
					foreach $resi_id_uniq (@resi_id_uniq) {
						$count++;
						map {s/^$resi_id_uniq$/$count/} @resi_id_all;
						@MOLECULETYPE_NUMBERED=@resi_id_all
					}
                    last;
                }
            }
            $MoleculeOldLine=substr($PDBLINE,23,3);
			$MoleculeCodeOld=substr($PDBLINE,21,1);
            $resi_id_new=substr($PDBLINE,17,4);
			if ("$resi_id_new" eq "GRPH" && "$TempStringAtomCode" eq '') {
				@split_PDBLINE=split(/\s+/, $PDBLINE);
				$temp_GRPH_Atom_code=substr($PDBLINE,13,4);
				$temp_GRPH_Atom_code=~s/\s+$//;
				push(@GRPH_Atom_Code,$temp_GRPH_Atom_code);
				push(@GRPH_Atom_id,$temp_GRPH_Atom_id);
				$Offset=min(@GRPH_Atom_id);
                push(@Temp_Distance_Coords,$x,$y,$z);
				undef($TempBonds_ref);
				undef($TempAngles_ref);
				undef($TempDihedrals_ref);
				undef($TempImpropers_ref);
				undef($ChargeData_ref);
				undef($AtomData_ref);
				$d=1;
			}
			else {
				if ($resi_id_new ne $resi_id_old) {
					chdir('/home/philip/HomeDir/misc/Unpacked-toppar_c36_jul19') || die "Try Running the Script in HomeDir/misc\n";
					our $g=0;
					#if ("$resi_id_new" eq "DPPC") {
						#($TempBonds_ref,$TempAngles_ref,$TempDihedrals_ref,$TempImpropers_ref,$ChargeData_ref,$AtomData_ref,$DPPCBondType_ref,$DPPCAngleType_ref,$DPPCDihedralType_ref)=&DPPC_build;
					#}
					#else {
						($TempBonds_ref,$TempAngles_ref,$TempDihedrals_ref,$TempImpropers_ref,$ChargeData_ref,$AtomData_ref,$TempBondTypePre_ref,$TempAngleTypePre_ref,$TempDihedralTypePre_ref,$TempImproperTypePre_ref,$Bond_typepre_out,$Angle_typepre_out,$Dihedral_typepre_out,$Improper_typepre_out)=&driver($resi_id_new);
						@TempBondTypePre = @$TempBondTypePre_ref;
						@TempAngleTypePre = @$TempAngleTypePre_ref;
						@TempDihedralTypePre = @$TempDihedralTypePre_ref;
						@TempImproperTypePre = @$TempImproperTypePre_ref;
						my @Bond_typepre_out = @$Bond_typepre_out;
						my @Angle_typepre_out = @$Angle_typepre_out;
						my @Dihedral_typepre_out = @$Dihedral_typepre_out;
						my @Improper_typepre_out = @$Improper_typepre_out;
						push(@Bond_type_out,@Bond_typepre_out);
						push(@Angle_type_out,@Angle_typepre_out);
						push(@Dihedral_type_out,@Dihedral_typepre_out);
						push(@Improper_type_out,@Improper_typepre_out);
					#}
				}
				$resi_id_old=substr($PDBLINE,17,4);
				if ($TempStringAtomCode eq '') {
					$TempStringAtomCode=substr($PDBLINE,12,4);
				}
				else {
					$TempStringAtomCode=join(' ',$TempStringAtomCode,substr($PDBLINE,12,4));
				}
			}
		}
	}
	close(PDBFILE);
	($TOTAL_ATOMS,$TOTAL_BONDS,$TOTAL_ANGLES,$TOTAL_DIHEDRALS,$TOTAL_IMPROPERS)=&total_numbered(\@X,\@BONDS,\@ANGLES,\@DIHEDRALS,\@IMPROPERS);
	@COUNT_ATOMS=(1..$TOTAL_ATOMS);
	@COUNT_BONDS=(1..$TOTAL_BONDS);
	@COUNT_ANGLES=(1..$TOTAL_ANGLES);
	@COUNT_DIHEDRALS=(1..$TOTAL_DIHEDRALS);
	@COUNT_IMPROPERS=(1..$TOTAL_IMPROPERS);
	return(\@X,\@Y,\@Z,\@BONDS,\@ANGLES,\@DIHEDRALS,\@IMPROPERS,\@COUNT_ATOMS,\@COUNT_BONDS,\@COUNT_ANGLES,\@COUNT_DIHEDRALS,\@COUNT_IMPROPERS,$TOTAL_ATOMS,$TOTAL_BONDS,$TOTAL_ANGLES,$TOTAL_DIHEDRALS,$TOTAL_IMPROPERS,\@ATOMCHARGE,\@ATOMTYPE_NUMBERED,\@BONDTYPE_NUMBERED,\@ANGLETYPE_NUMBERED,\@DIHEDRALTYPE_NUMBERED,\@IMPROPERTYPE_NUMBERED,\@MOLECULETYPE_NUMBERED,\@ATOM_MASSES,\@Bond_type_out,\@Angle_type_out,\@Dihedral_type_out,\@Improper_type_out,$atom_mass_code);
}



sub driver {
	my $TempStringBonds='';
	my $i=0;
	my $j=0;
	my @foobar;
	my @TempBondsUniq;
	my $TempBondsUniq_ref=0;
	my $count=0;
	my @TempBondsNumbered;
	my @Total_Molecules;
	my $TempBonds_ref=0;
	my @TempStringImpropers='';
	my $TempAngles_ref=0;
	my @matching_indices;
	my $bondsnumbered=0;
	my $dihedralsnumbered=0;
	my $offset=0;
	my $TempStringAngles='';
	my $TempStringDihedrals='';
	my @TempDihedralsNumbered;
	my @TempImpropersNumbered;
	my @tempimpropersnumbered;
	my @impropersnumbered;
	my $file;
	my $cwd;
    my $resi_id= @_[0];
	opendir($cwd,".");
	local(@directory)=readdir($cwd);
	closedir($cwd);
	foreach $file (@directory) {
		if ( $g==1 ) {
			last;
		}
		if ( -d $file && $file ne "." && $file ne ".."){
			chdir($file);
			&driver;
			chdir("..") || die "oh god\n";
		}
		elsif ( -T $file ){
			open(FILE,$file) || die "could not open the txt file";
			while(<FILE>){
				if (/^[rR][eE][sS][iI]/ && $i==1){
					$i=0;
				}
				if (/\s*$resi_id[\s*,]/ && $i==0){
					$i=1;
				}
				if (/^[rR][eE][sS][iI][ ](.{4,7})[ ]/ && $i==1) {
					print "\n$_\nin $file\n";
					print File::Spec->rel2abs($file) . "\n";
					while(1==1) {	
						print "is this correct (y/n)\n";
						$USERINPUT=<>;
						if ( $USERINPUT=~/^[yY]/ ) {
							$i=3;
							($chargedata_ref,$atomdata_ref)=&energy_data(*FILE);
                            ($i,$g,$TempStringBonds)=&bonds(*FILE,$i);
							@TempImpropers=&impropers(*FILE);
							@TempBonds=split(/\s+/,$TempStringBonds);
                            $TempBonds_ref=\@TempBonds;
                            @TempBonds=&remove($TempBonds_ref);
                            @TempBondsUniq=uniq(@TempBonds);
                            $TempBondsUniq_ref=\@TempBondsUniq;
                            @TempAngles=&angles($TempBondsUniq_ref,$TempBonds_ref);
                            @TempDihedrals=&dihedrals($TempBondsUniq_ref,$TempBonds_ref);
							if ( $file =~ /_([a-zA-Z0-9]*)\.rtf/ ) {
								$file_pre = $1; 
								$file_pre = $file_pre . '.prm';
								foreach $sfile (@directory) {
									if ( $sfile =~ /$file_pre/ ) {
										$param_file = $sfile;
									}
								}
								$Param_File = cwd . "/$param_file";
							}
							elsif ( $file =~ /(.*\.str)|(.*\.inp)/ ) {
								$file_pre = $1;
								$Param_File = cwd . "/$file_pre";
							}
							($TempBondsnw_ref,$TempBondType_ref,$Bond_type_out)=&Param_act($atomdata_ref,\@TempBonds,'BONDS',2,$Param_File);
							($TempAnglesnw_ref,$TempAngleType_ref,$Angle_type_out)=&Param_act($atomdata_ref,\@TempAngles,'ANGLES',3,$Param_File);
							($TempDihedralsnw_ref,$TempDihedralType_ref,$Dihedral_type_out)=&Param_act($atomdata_ref,\@TempDihedrals,'DIHEDRALS',4,$Param_File);
							($TempImpropersnw_ref,$TempImproperType_ref,$Improper_type_out)=&Param_act($atomdata_ref,\@TempImpropers,'IMPROPER',4,$Param_File);
							last;
						}
						elsif ( $USERINPUT=~/[nN]/ ) {
							last;
						}
						else {
							print "Invalid input try again\n";
							next;
						}
					}
				}
			}
			$i=0;
			close(FILE);
		}
	}
    #print "$TempStringBonds\n";
    #print "@TempBondsScattered\n";
    #print "@TempBondsUniq\n";
    #print "@TempBondsNumbered";
    #print "@BONDS\n";
    #print "@ANGLES\n";
    #print "@DIHEDRALS\n";
    #print "@IMPROPERS\n";
    #print "@Total_Molecules";
    #print "@TempAnglesNumbered";
    #print "@TempBonds\n\n";
    #print "@TempAngles\n\n";
    #print "$TempStringAngles\n";
    #print "@TempDihedrals\n\n";
    #print "@TempImpropers\n";
	return($TempBondsnw_ref,$TempAnglesnw_ref,$TempDihedralsnw_ref,$TempImpropersnw_ref,$chargedata_ref,$atomdata_ref,$TempBondType_ref,$TempAngleType_ref,$TempDihedralType_ref,$TempImproperType_ref,$Bond_type_out,$Angle_type_out,$Dihedral_type_out,$Improper_type_out);
}



sub remove {
	my @remove_indice;
	my $TempArrayRef=@_[0];
	my @TempArray=@$TempArrayRef;
	@remove_indice=reverse(indexes { /LP/ || /[+-]/ } @TempArray);
		foreach $remove (@remove_indice) {
			if ($remove%2==0) {
				splice(@TempArray,$remove,2);
			}
			else {
				splice(@TempArray,($remove-1),2);
			}
		
		}
	return @TempArray;
}



sub energy_data {
	my %chargedata;
	my %atomdata;
	my $TempStringData;
	my $AtomCode;
	my $DataCode;
	my $Charge;
	my $file=@_[0];
	while(<$file>) {
		if (/^[aA][tT][oO][mM]/) {
			$TempStringData=substr($_,4,21);
			$TempStringData=~s/^\s+|\s+$//g;
			($AtomCode,$DataCode,$Charge)=split(/\s+/,$TempStringData);
			$chargedata{$AtomCode}=$Charge;
			$atomdata{$AtomCode}=$DataCode;
		}
		elsif (/^[bB][oO][nN][dD] |^[dD][oO][uU][bB]/) {
			last;
		}
	}
	return(\%chargedata,\%atomdata);
}



sub bonds {
    my $file=@_[0];
	my $i=@_[1];
	my $TempStringBonds='';
	my @TempBonds;
    {do {
        if (/^[bB][oO][nN][dD] |^[dD][oO][uU][bB]/ && ($i==3 || $i==2)) {
            chop;
            print "$_\n";
            if ( $TempStringBonds eq '' ) {
                if (/^[bB][oO][nN][dD] /) {
					s/\!.*[^\n]//s;
					s/'//g;
                    $TempStringBonds=substr($_,5);
                }
                elsif (/^[dD][oO][uU][bB]/) {
					s/\!.*[^\n]//s;
					s/'//g;
                    $TempStringBonds=substr($_,7);
                }
            }
            else {
                if (/^[bB][oO][nN][dD] /) {
					s/\!.*[^\n]//s;
					s/'//g;
                    $TempStringBonds=join(' ',$TempStringBonds,substr($_,5));
                }
                elsif (/^[dD][oO][uU][bB]/) {
					s/\!.*[^\n]//s;
					s/'//g;
                    $TempStringBonds=join(' ',$TempStringBonds,substr($_,7));
                }
            }
            $i=2;
        }
        if (/^[^bB][^oO][^nN][^dD] |^[^dD][^oO][^uU][^bB]/ && $i==2) {
            $i=0;
            $g=1;					
            last;						
        }
    } while (<$file>)};
	$TempStringBonds=~s/^\s+//;
    return($i,$g,$TempStringBonds);
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
		if ($length_matching_indices > 2) {
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



sub impropers {
	my $file=@_[0];
	my $i=3;
	my $TempStringImpropers='';
	my @TempImpropers;
	{do {
		if (/^[iI][mM][pP][rRhH]/ && ($i==1 || $i==3)) {
			chop;
			if ( $TempStringImpropers eq '' ) {
				$TempStringImpropers=substr($_,5);
			}
			else {
				$TempStringImpropers=join(' ',$TempStringImpropers,substr($_,5));
			}
			$i=1;
		}
		elsif ((/^[^iI][^mM][^pP][^rRhH]/ && $i==1) || /^[rR][eE][sS][iI]/) {
			$i=0;
			@TempImpropers=split(/\s+/,$TempStringImpropers);
			last;
		}
	} while (<$file>)};
	return @TempImpropers;
}



sub total_numbered {
	my $x= @_[0];
	my $bonds= @_[1];
	my $angles= @_[2];
	my $dihedrals= @_[3];
	my $impropers= @_[4];
	my @X= @$x;
	my @BONDS= @$bonds;
	my @ANGLES= @$angles;
	my @DIHEDRALS= @$dihedrals;
	my @IMPROPERS= @$impropers;
	$TOTAL_ATOMS= @X;
	$length_BONDS= @BONDS;
	$length_ANGLES= @ANGLES;
	$length_DIHEDRALS= @DIHEDRALS;
	$length_IMPROPERS= @IMPROPERS;
	$TOTAL_BONDS=($length_BONDS / 2);
	$TOTAL_ANGLES=($length_ANGLES / 3);
	$TOTAL_DIHEDRALS=($length_DIHEDRALS / 4);
	$TOTAL_IMPROPERS=($length_IMPROPERS / 4);
	return($TOTAL_ATOMS,$TOTAL_BONDS,$TOTAL_ANGLES,$TOTAL_DIHEDRALS,$TOTAL_IMPROPERS);
}



sub number {
	my $TempStringAtomCode=@_[0];
	my $TempBonds_ref=@_[1];
	my $TempAngles_ref=@_[2];
	my $TempDihedrals_ref=@_[3];
	my $TempImpropers_ref=@_[4];
	my $TempBonds_GRPH_ref=@_[5];
	my $TempAngles_GRPH_ref=@_[6];
	my $TempDihedrals_GRPH_ref=@_[7];
	$TempStringAtomCode=~ s/^\s+|\s+$//g;
	my @TempAtomCode=split(/\s+/,$TempStringAtomCode);
	my @TempBonds= @$TempBonds_ref;
	my @TempAngles= @$TempAngles_ref;
	my @TempDihedrals= @$TempDihedrals_ref;
	my @TempImpropers= @$TempImpropers_ref;
	my @TempBonds_GRPH=@$TempBonds_GRPH_ref;
	my @TempAngles_GRPH=@$TempAngles_GRPH_ref;
	my @TempDihedrals_GRPH=@$TempDihedrals_GRPH_ref;
	my @TempBondsNumbered;
	my @TempAnglesNumbered;
	my @TempDihedralsNumbered;
	my @TempImpropersNumbered;
	my $TempStringBonds="@TempBonds";
	my $TempStringAngles="@TempAngles";
	my $TempStringDihedrals="@TempDihedrals";
	my $TempStringImpropers="@TempImpropers";
	foreach $Atom (@TempAtomCode) {
		$count+=1;
		$TempStringBonds=~s/\b\Q$Atom\E\b/$count/g;
		$TempStringAngles=~s/\b\Q$Atom\E\b/$count/g;
		$TempStringDihedrals=~s/\b\Q$Atom\E\b/$count/g;
		$TempStringImpropers=~s/\b\Q$Atom\E\b/$count/g;
	}	
	@TempBondsNumbered=split(/\s+/,$TempStringBonds);
	@TempAnglesNumbered=split(/\s+/,$TempStringAngles);
	@TempDihedralsNumbered=split(/\s+/,$TempStringDihedrals);
	@TempImpropersNumbered=split(/\s+/,$TempStringImpropers);
	while ("@TempBonds_GRPH" ne '') {
		$TempBonds_GRPH=shift(@TempBonds_GRPH);
		$TempBonds_GRPH=$TempBonds_GRPH;
		push(@TempBondsNumbered,$TempBonds_GRPH);
	}
	while ("@TempAngles_GRPH" ne '') {
		$TempAngles_GRPH=shift(@TempAngles_GRPH);
		$TempAngles_GRPH=$TempAngles_GRPH;
		push(@TempAnglesNumbered,$TempAngles_GRPH);
	}
	while ("@TempDihedrals_GRPH" ne '') {
		$TempDihedrals_GRPH=shift(@TempDihedrals_GRPH);
		$TempDihedrals_GRPH=$TempDihedrals_GRPH;
		push(@TempDihedralsNumbered,$TempDihedrals_GRPH);
	}
	return(\@TempBondsNumbered,\@TempAnglesNumbered,\@TempDihedralsNumbered,\@TempImpropersNumbered)
}



sub build {
	my $TempBondsNumbered_ref=@_[0];
	my $TempAnglesNumbered_ref=@_[1];
	my $TempDihedralsNumbered_ref=@_[2];
	my $TempImpropersNumbered_ref=@_[3];
	my @TempBondsNumbered=@$TempBondsNumbered_ref;
	my @TempAnglesNumbered=@$TempAnglesNumbered_ref;
	my @TempDihedralsNumbered=@$TempDihedralsNumbered_ref;
	my @TempImpropersNumbered=@$TempImpropersNumbered_ref;
	push(@BONDS,@TempBondsNumbered);
	push(@ANGLES,@TempAnglesNumbered);
	push(@DIHEDRALS,@TempDihedralsNumbered);
	push(@IMPROPERS,@TempImpropersNumbered);
	return(\@BONDS,\@ANGLES,\@DIHEDRALS,\@IMPROPERS);
}



sub build_data {
	my $ChargeData_ref=@_[0];
	my $AtomData_ref=@_[1];
	my $TempStringAtomCode=@_[2];
	my $TempBonds_ref=@_[3];
	my $TempAngles_ref=@_[4];
	my $TempDihedrals_ref=@_[5];
	my $TempImpropers_ref=@_[6];
	my $grph_atom_code=@_[7];
	my $temp_grph_bonds=@_[8];
	my $temp_grph_angles=@_[9];
	my $temp_grph_dihedrals=@_[10];
	my $Offset=@_[11];
	my $GRPH_Charge=@_[12];
	my $resi_id_old=@_[13];
	$TempStringAtomCode=~ s/^\s+|\s+$//g;
	#my $DPPCBondType_ref=@_[14];
	#my $DPPCAngleType_ref=@_[15];
	#my $DPPCDihedralType_ref=@_[16];
	#my @DPPCBondType=@$DPPCBondType_ref;
	#my @DPPCAngleType=@$DPPCAngleType_ref;
	#my @DPPCDihedralType=@$DPPCDihedralType_ref;
	my @GRPH_Charge=@$GRPH_Charge;
	my @GRPH_Atom_Code=@$grph_atom_code;
	my @Temp_GRPH_Bonds=@$temp_grph_bonds;
	my @Temp_GRPH_Angles=@$temp_grph_angles;
	my @Temp_GRPH_Dihedrals=@$temp_grph_dihedrals;
	my $h;
	my $i;
	my $j;
	my $g;
	my %ChargeData=%$ChargeData_ref;
	my %AtomData=%$AtomData_ref;
	my @TempBonds=@$TempBonds_ref;
	my @TempAngles=@$TempAngles_ref;
	my @TempDihedrals=@$TempDihedrals_ref;
	my @TempImpropers=@$TempImpropers_ref;
	my @TempBondsData_sorted;
	my @TempAnglesData_sorted;
	my @TempDihedralsData_sorted;
	my @TempImpropersData_sorted;
	my @TempAtomCode=split(/\s+/,$TempStringAtomCode);
	my @TempAtomCode_copy=@TempAtomCode;
	foreach $AtomCode (@TempAtomCode) {
		map {s/^$AtomCode$/$AtomData{$AtomCode}/} @TempBonds;
		map {s/^$AtomCode$/$AtomData{$AtomCode}/} @TempAngles;
		map {s/^$AtomCode$/$AtomData{$AtomCode}/} @TempDihedrals;
		map {s/^$AtomCode$/$AtomData{$AtomCode}/} @TempImpropers;
		map {s/^$AtomCode$/$AtomData{$AtomCode}/} @TempAtomCode_copy;
		$TempStringAtomCode=~s/\b$AtomCode\b/$ChargeData{$AtomCode}/g;
	}
	my @TempAtomCharge=split(/\s+/,$TempStringAtomCode);
	my @TempAtomMassCode=@TempAtomCode_copy;
	if ("@GRPH_Atom_Code" ne '' && "@TempAtomCode" eq '') {
		@TempBonds=();
		@TempAngles=();
		@TempDihedrals=();
		@TempAtomMassCode=@GRPH_Atom_Code;
		foreach $Temp_GRPH_Bonds (@Temp_GRPH_Bonds) {
			push(@TempBonds,@GRPH_Atom_Code[($Temp_GRPH_Bonds-$Offset)]);
		} 
		foreach $Temp_GRPH_Angles (@Temp_GRPH_Angles) {
			push(@TempAngles,@GRPH_Atom_Code[($Temp_GRPH_Angles-$Offset)]);
		}
		foreach $Temp_GRPH_Dihedrals (@Temp_GRPH_Dihedrals) {
			push(@TempDihedrals,@GRPH_Atom_Code[($Temp_GRPH_Dihedrals-$Offset)]);
		}
	}
	my $LengthTempBondsData=@TempBonds;
	my $LengthTempAnglesData=@TempAngles;
	my $LengthTempDihedralsData=@TempDihedrals;
	my $LengthTempImpropersData=@TempImpropers;
	my @TempBondsData_splice=@TempBonds;
	my @TempAnglesData_splice=@TempAngles;
	my @TempDihedralsData_splice=@TempDihedrals;
	my @TempImpropersData_splice=@TempImpropers;
	my @TempBondsData_sort;
	my @TempAnglesData_sort;
	my @TempDihedralsData_sort;
	my @TempImpropersData_sort;
	for($h=0;$h<($LengthTempBondsData/2); $h++) {
		@TempBondsData_sort=splice(@TempBondsData_splice,0,2);
		@TempBondsData_sorted=sort(@TempBondsData_sort);
		push(@TempBondType,"@TempBondsData_sorted");
	}
	for($i=0;$i<($LengthTempAnglesData/3);$i++) {
		@TempAnglesData_sort=splice(@TempAnglesData_splice,0,3);
		push(@TempAngleType,"@TempAnglesData_sort");
	}
	#if ($resi_id_old ne 'DPPC') {
		for($j=0;$j<($LengthTempDihedralsData/4);$j++) {
			@TempDihedralsData_sort=splice(@TempDihedralsData_splice,0,4);
			push(@TempDihedralType,"@TempDihedralsData_sort");
		}
	#}
	#else {
		#push(@TempBondType,@DPPCBondType);
		#push(@TempAngleType,@DPPCAngleType);
		#push(@TempDihedralType,@DPPCDihedralType);
	#}
	for($g=0;$g<($LengthTempImpropersData/4);$g++) {
		@TempImpropersData_sort=splice(@TempImpropersData_splice,0,4);
		@TempImpropersData_sorted=sort(@TempImpropersData_sort);
		push(@TempImproperType,"@TempImpropersData_sorted");
	}
	push(@ATOMCHARGE,@TempAtomCharge,@GRPH_Charge);
	return(\@TempBondType,\@TempAngleType,\@TempDihedralType,\@TempImproperType,\@TempAtomMassCode,\@ATOMCHARGE);
}



sub data_type_numbered {
	my $TempBondType_ref=@_[0];
	my $TempAngleType_ref=@_[1];
	my $TempDihedralType_ref=@_[2];
	my $TempImproperType_ref=@_[3];
	my @TempBondType=@$TempBondType_ref;
	my @TempAngleType=@$TempAngleType_ref;
	my @TempDihedralType=@$TempDihedralType_ref;
	my @TempImproperType=@$TempImproperType_ref;
	my @TempBondType_uniq=uniq(@TempBondType);
	my @TempAngleType_uniq=uniq(@TempAngleType);
	my @TempDihedralType_uniq=uniq(@TempDihedralType);
	my @TempImproperType_uniq=uniq(@TempImproperType);
	my @matching_indices;
	foreach $tempangletype_uniqcp (@TempAngleType_uniq) {
		$reversed_tempangletype_uniqcp = join(" ", reverse split(" ", $tempangletype_uniqcp));
		if($reversed_tempangletype_uniqcp ne $tempangletype_uniqcp) {
			@matching_indices=indexes { /\b\Q$reversed_tempangletype_uniqcp\E\b/ } @TempAngleType_uniq;
			foreach $indice (@matching_indices) {
				splice(@TempAngleType_uniq,$indice,1);
			}
		}
	}
	foreach $tempdihedraltype_uniqcp (@TempDihedralType_uniq) {
		$reversed_tempdihedraltype_uniqcp = join(" ", reverse split(" ", $tempdihedraltype_uniqcp));
		if($reversed_tempdihedraltype_uniqcp ne $tempdihedraltype_uniqcp) {
			@matching_indices=indexes { /\b\Q$reversed_tempdihedraltype_uniqcp\E\b/ } @TempDihedralType_uniq;
			foreach $indice (@matching_indices) {
				splice(@TempDihedralType_uniq,$indice,1);
			}
		}
	}
	my $count_bond=0;
	my $count_angle=0;
	my $count_dihedral=0;
	my $count_improper=0;
	foreach $tempbondtype_uniq (@TempBondType_uniq) {
		if ( $tempbondtype_uniq eq 'a113' ) {
			print 'beef';
		}
		$count_bond++;
		map {s/^$tempbondtype_uniq$/$count_bond/} @TempBondType;
	}
	foreach $tempangletype_uniq (@TempAngleType_uniq) {
		$count_angle++;
		$reversed_angle_type = join(" ", reverse split(" ", $tempangletype_uniq));
		map {s/^$tempangletype_uniq$/$count_angle/} @TempAngleType;
		map {s/^$reversed_angle_type$/$count_angle/} @TempAngleType;
	}
	foreach $tempdihedraltype_uniq (@TempDihedralType_uniq) {
		$count_dihedral++;
		$reversed_dihedral_type = join(" ", reverse split(" ", $tempdihedraltype_uniq));
		map {s/^$tempdihedraltype_uniq$/$count_dihedral/} @TempDihedralType;
		map {s/^$reversed_dihedral_type$/$count_dihedral/} @TempDihedralType;
	}
	foreach $tempimpropertype_uniq (@TempImproperType_uniq) {
		$count_improper++;
		map {s/^$tempimpropertype_uniq$/$count_improper/} @TempImproperType;
	}
	my @BONDTYPE_NUMBERED=@TempBondType;
	my @ANGLETYPE_NUMBERED=@TempAngleType;
	my @DIHEDRALTYPE_NUMBERED=@TempDihedralType;
	my @IMPROPERTYPE_NUMBERED=@TempImproperType;
	return(\@BONDTYPE_NUMBERED,\@ANGLETYPE_NUMBERED,\@DIHEDRALTYPE_NUMBERED,\@IMPROPERTYPE_NUMBERED,\@TempAngleType_uniq,\@TempDihedralType_uniq)
}



sub atom_mass_code {
	my $TempAtomMassCode=@_[0];
	my @TempAtomMassCode=@$TempAtomMassCode;
	my @TempStringAtomMass;
	my %AtomMassValues;
	my $TempAtomMass_uniq;
	push(@AtomMassCodeTotal,@TempAtomMassCode);
	return(\@AtomMassCodeTotal);
}



sub atom_mass_code_numbered {
	my @ATOM_MASSES;
	$AtomMassCodeTotal_ref=@_[0];
	@AtomMassCodeTotal=@$AtomMassCodeTotal_ref;
	my @TempAtomMass_uniq=uniq(@AtomMassCodeTotal);
	open(MASSFILE,"/home/philip/HomeDir/misc/Cleaned_CHARMM_Data/Atom_Mass.prm") || die "could not open .prm file";
	while(<MASSFILE>) {
		@TempStringAtomMass=split(/\s+/,$_);
		$AtomMassValues{@TempStringAtomMass[2]}=@TempStringAtomMass[3];
	}
	close(MASSFILE);
	foreach $TempAtomMass_uniq (@TempAtomMass_uniq) {
		$growth++;
		push(@ATOM_MASSES,$TempAtomMass_uniq,$growth);
		map {s/^$TempAtomMass_uniq$/$AtomMassValues{$_}/} @ATOM_MASSES;
		map {s/^$TempAtomMass_uniq$/$growth/} @AtomMassCodeTotal;
	}
	my @ATOMTYPE_NUMBERED=@AtomMassCodeTotal;
	return(\@ATOMTYPE_NUMBERED,\@ATOM_MASSES,\@TempAtomMass_uniq);
}



sub LAMMPS_data_file_builder {
	my $x;
	my $y;
	my $z;
	my $bonds;
	my $angles;
	my $dihedrals;
	my $impropers;
	my $count_atoms;
	my $count_bonds;
	my $count_angles;
	my $count_dihedrals;
	my $count_impropers;
	my $atomcharge;
	my $atomtype_numbered;
	my $bondtype_numbered;
	my $angletype_numbered;
	my $dihedraltype_numbered;
	my $impropertype_numbered;
	my $moleculetype_numbered;
	my $atom_masses;
	my $TOTAL_ATOMS;
	my $TOTAL_BONDS;
	my $TOTAL_ANGLES;
	my $TOTAL_DIHEDRALS;
	my $TOTAL_IMPROPERS;
	my $atom_mass_code;
	my $TempImproperType_ref;
	($x,$y,$z,$bonds,$angles,$dihedrals,$impropers,$count_atoms,$count_bonds,$count_angles,$count_dihedrals,$count_impropers,$TOTAL_ATOMS,$TOTAL_BONDS,$TOTAL_ANGLES,$TOTAL_DIHEDRALS,$TOTAL_IMPROPERS,$atomcharge,$atomtype_numbered,$bondtype_numbered,$angletype_numbered,$dihedraltype_numbered,$impropertype_numbered,$moleculetype_numbered,$atom_masses,$TempBondType_ref,$TempAngleType_ref,$TempDihedralType_ref,$TempImproperType_ref,$atom_mass_code)=&build_from_pdb;
	&write_data_file($x,$y,$z,$bonds,$angles,$dihedrals,$impropers,$count_atoms,$count_bonds,$count_angles,$count_dihedrals,$count_impropers,$TOTAL_ATOMS,$TOTAL_BONDS,$TOTAL_ANGLES,$TOTAL_DIHEDRALS,$TOTAL_IMPROPERS,$atomcharge,$atomtype_numbered,$bondtype_numbered,$angletype_numbered,$dihedraltype_numbered,$impropertype_numbered,$moleculetype_numbered,$atom_masses,$TempBondType_ref,$TempAngleType_ref,$TempDihedralType_ref,$TempImproperType_ref,$atom_mass_code);
	my @X=@$x;
	my @Y=@$y;
	my @Z=@$z;
	my @ATOMTYPE_NUMBERED=@$atomtype_numbered;
	my @BONDTYPE_NUMBERED=@$bondtype_numbered;
	my @ANGLETYPE_NUMBERED=@$angletype_numbered;
	my @DIHEDRALTYPE_NUMBERED=@$dihedraltype_numbered;
	my @IMPROPERTYPE_NUMBERED=@$impropertype_numbered;
	my @MOLECULETYPE_NUMBERED=@$moleculetype_numbered;
	my @ATOMCHARGE=@$atomcharge;
	my @BONDS=@$bonds;
	my @ANGLES=@$angles;
	my @DIHEDRALS=@$dihedrals;
	my @IMPROPERS=@$impropers;
	my @COUNT_ATOMS=@$count_atoms;
	my @COUNT_BONDS=@$count_bonds;
	my @COUNT_ANGLES=@$count_angles;
	my @COUNT_DIHEDRALS=@$count_dihedrals;
	my @COUNT_IMPROPERS=@$count_impropers;
	print "\n$TOTAL_ATOMS\n";
	print "$TOTAL_BONDS\n";
	print "$TOTAL_ANGLES\n";
	print "$TOTAL_DIHEDRALS\n";
	print "$TOTAL_IMPROPERS\n\n";
	while ("@X" ne '') {
		my $X=shift(@X);
		my $Y=shift(@Y);
		my $Z=shift(@Z);
		my $ATOMTYPE_NUMBERED=shift(@ATOMTYPE_NUMBERED);
		my $ATOMCHARGE=shift(@ATOMCHARGE);
		print "$ATOMTYPE_NUMBERED $ATOMCHARGE   $X   $Y   $Z\n";
	}
	print "\nBONDS\n";
	while ("@BONDS" ne '') {
		@BONDS_splice=splice(@BONDS,0,2);
		$bondtype=shift(@BONDTYPE_NUMBERED);
		print "@BONDS_splice   $bondtype\n";
	}
	print "\nANGLES\n";
	while ("@ANGLES" ne '') {
		@ANGLES_splice=splice(@ANGLES,0,3);
		$angletype=shift(@ANGLETYPE_NUMBERED);
		print "@ANGLES_splice   $angletype\n";
	}
	print "\nDIHEDRALS\n";
	while ("@DIHEDRALS" ne '') {
		@DIHEDRALS_splice=splice(@DIHEDRALS,0,4);
		$dihedraltype=shift(@DIHEDRALTYPE_NUMBERED);
		print "@DIHEDRALS_splice   $dihedraltype\n";
	}
	print "\nIMPROPERS\n";
	while ("@IMPROPERS" ne '') {
		@IMPROPERS_splice=splice(@IMPROPERS,0,4);
		$impropertype=shift(@IMPROPERTYPE_NUMBERED);
		print "@IMPROPERS_splice   $impropertype\n";
	}
	print "\n@COUNT_ATOMS\n";
	print "@COUNT_BONDS\n";
	print "@COUNT_ANGLES\n";
	print "@COUNT_DIHEDRALS\n";
	print "@COUNT_IMPROPERS\n";
}



sub write_data_file {
	my $x=shift;
	my $y=shift;
	my $z=shift;
	my $bonds=shift;
	my $angles=shift;
	my $dihedrals=shift;
	my $impropers=shift;
	my $count_atoms=shift;
	my $count_bonds=shift;
	my $count_angles=shift;
	my $count_dihedrals=shift;
	my $count_impropers=shift;
	my $TOTAL_ATOMS=shift;
	my $TOTAL_BONDS=shift;
	my $TOTAL_ANGLES=shift;
	my $TOTAL_DIHEDRALS=shift;
	my $TOTAL_IMPROPERS=shift;
	my $atomcharge=shift;
	my $atomtype_numbered=shift;
	my $bondtype_numbered=shift;
	my $angletype_numbered=shift;
	my $dihedraltype_numbered=shift;
	my $impropertype_numbered=shift;
	my $moleculetype_numbered=shift;
	my $atom_masses=shift;
	my $TempBondType_ref = shift;
	my $TempAngleType_ref = shift;
	my $TempDihedralType_ref = shift;
	my $TempImproperType_ref = shift;
	my $atom_mass_code = shift;
	my @array_Check=@$atom_mass_code;
	my @X=@$x;
	my @Y=@$y;
	my @Z=@$z;
	my @BONDS=@$bonds;
	my @ANGLES=@$angles;
	my @DIHEDRALS=@$dihedrals;
	my @IMPROPERS=@$impropers;
	my @COUNT_ATOMS=@$count_atoms;
	my @COUNT_BONDS=@$count_bonds;
	my @COUNT_ANGLES=@$count_angles;
	my @COUNT_DIHEDRALS=@$count_dihedrals;
	my @COUNT_IMPROPERS=@$count_impropers;
	my @ATOMCHARGE=@$atomcharge;
	my @ATOMTYPE_NUMBERED=@$atomtype_numbered;
	my @BONDTYPE_NUMBERED=@$bondtype_numbered;
	my @ANGLETYPE_NUMBERED=@$angletype_numbered;
	my @DIHEDRALTYPE_NUMBERED=@$dihedraltype_numbered;
	my @IMPROPERTYPE_NUMBERED=@$impropertype_numbered;
	my @MOLECULETYPE_NUMBERED=@$moleculetype_numbered;
	my @ATOM_MASSES=@$atom_masses;
	my $TOTAL_ATOMTYPE=max(@ATOMTYPE_NUMBERED);
	my $TOTAL_BONDTYPE=max(@BONDTYPE_NUMBERED);
	my $TOTAL_ANGLETYPE=max(@ANGLETYPE_NUMBERED);
	my $TOTAL_DIHEDRALTYPE=max(@DIHEDRALTYPE_NUMBERED);
	my $TOTAL_IMPROPERTYPE=max(@IMPROPERTYPE_NUMBERED);
	print "what is the name of the soon to be created data file\n";
	$DATAFILE=<>;
	chop $DATAFILE;
	$DATADIR=$DATAFILE;
	$DATADIR=~s/\..*//;
	mkdir("/home/philip/HomeDir/misc/LAMMPS_Data_Files/$DATADIR");
	chdir("/home/philip/HomeDir/misc/LAMMPS_Data_Files/$DATADIR") || die "unable to open /home/philip/HomeDir/LAMMPS_Data_Files/$DATADIR";
	&data_collector($TempBondType_ref,$TempAngleType_ref,$TempDihedralType_ref,$TempImproperType_ref,$DATADIR,$atom_mass_code);
	open(DATAFILE,">$DATAFILE") || die "unable to open the output datafile specified";
	print DATAFILE "\n\n$TOTAL_ATOMS atoms\n$TOTAL_BONDS bonds\n$TOTAL_ANGLES angles\n$TOTAL_DIHEDRALS dihedrals\n$TOTAL_IMPROPERS impropers";
	print DATAFILE "\n\n$TOTAL_ATOMTYPE atom types\n$TOTAL_BONDTYPE bond types\n$TOTAL_ANGLETYPE angle types\n";
	if ("$TOTAL_DIHEDRALTYPE" ne '') {
		print DATAFILE "$TOTAL_DIHEDRALTYPE dihedral types\n";
	}
	if ("$TOTAL_IMPROPERTYPE" ne '') {
		print DATAFILE "$TOTAL_IMPROPERTYPE improper types";
	}
	print DATAFILE "\nMasses\n\n";
	while ("@ATOM_MASSES" ne '') {
		($MASS1,$ATOM1)=splice(@ATOM_MASSES,0,2);
		$MASS1=~s/0+$//;
		printf DATAFILE ("%9s $MASS1\n",$ATOM1);
	}
	print DATAFILE "\nAtoms\n\n";
	while ("@X" ne '') {
		my $X=shift(@X);
		my $Y=shift(@Y);
		my $Z=shift(@Z);
		my $COUNT_ATOMS=shift(@COUNT_ATOMS);
		my $MOLECULETYPE_NUMBERED=shift(@MOLECULETYPE_NUMBERED);
		my $ATOMTYPE_NUMBERED=shift(@ATOMTYPE_NUMBERED);
		my $ATOMCHARGE=shift(@ATOMCHARGE);
		printf DATAFILE ("%7s $MOLECULETYPE_NUMBERED $ATOMTYPE_NUMBERED %6s %7s %7s %7s\n",$COUNT_ATOMS,$ATOMCHARGE,$X,$Y,$Z);
	}
	if ("@BONDS" ne '') {
		print DATAFILE "\n\n\nBonds\n\n";
	}
	while ("@BONDS" ne '') {
		$COUNT_BONDS=shift(@COUNT_BONDS);
		$BONDTYPE_NUMBERED=shift(@BONDTYPE_NUMBERED);
		($BOND1,$BOND2)=splice(@BONDS,0,2);
		printf DATAFILE ("%7s $BONDTYPE_NUMBERED %7s %7s\n",$COUNT_BONDS,$BOND1,$BOND2);
	}
	if ("@ANGLES" ne '') {
		print DATAFILE "\n\n\nAngles\n\n"
	}
	while ("@ANGLES" ne '') {
		$COUNT_ANGLES=shift(@COUNT_ANGLES);
		$ANGLETYPE_NUMBERED=shift(@ANGLETYPE_NUMBERED);
		($ANGLE1,$ANGLE2,$ANGLE3)=splice(@ANGLES,0,3);
		printf DATAFILE ("%7s $ANGLETYPE_NUMBERED %7s %7s %7s\n",$COUNT_ANGLES,$ANGLE1,$ANGLE2,$ANGLE3);
	}
	if ("@DIHEDRALS" ne '') {
		print DATAFILE "\n\n\nDihedrals\n\n";
	}
	while ("@DIHEDRALS" ne '') {
		$COUNT_DIHEDRALS=shift(@COUNT_DIHEDRALS);
		$DIHEDRALTYPE_NUMBERED=shift(@DIHEDRALTYPE_NUMBERED);
		($DIHEDRAL1,$DIHEDRAL2,$DIHEDRAL3,$DIHEDRAL4)=splice(@DIHEDRALS,0,4);
		printf DATAFILE ("%7s $DIHEDRALTYPE_NUMBERED %7s %7s %7s %7s\n",$COUNT_DIHEDRALS,$DIHEDRAL1,$DIHEDRAL2,$DIHEDRAL3,$DIHEDRAL4);
	}
	if ("@IMPROPERS" ne '') {
		print DATAFILE "\n\n\nImpropers\n\n"
	}
	while ("@IMPROPERS" ne '') {
		$COUNT_IMPROPERS=shift(@COUNT_IMPROPERS);
		$IMPROPERTYPE_NUMBERED=shift(@IMPROPERTYPE_NUMBERED);
		($IMPROPER1,$IMPROPER2,$IMPROPER3,$IMPROPER4)=splice(@IMPROPERS,0,4);
		printf DATAFILE ("%7s $IMPROPERTYPE_NUMBERED %7s %7s %7s %7s\n",$COUNT_IMPROPERS,$IMPROPER1,$IMPROPER2,$IMPROPER3,$IMPROPER4);
	}
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
	return($distance)
}



sub graphene_build {
	open(LOGFILE,">/home/philip/HomeDir/misc/LAMMPS_Data_Files/file.log") || die "unable to open logfile";
	my $temp_distance_coords=@_[0];
	my $grph_atom_id=@_[1];
	my $grph_atom_code=@_[2];
	my @GRPH_Atom_id=@$grph_atom_id;
	my $GRPH_Atom_id;
	my $GRPH_Atom_id_Copy;
	my @GRPH_bonds;
	my @Temp_Distance_Coords;
	my $distance;
	my @Temp_Distance_Coords_Copy;
	my @GRPH_Atom_Code=@$grph_atom_code;
	my $GRPH_Atom_Code;
	my @GRPH_Atom_Code_copy;
	my $GRPH_Atom_Code_copy;
	my @TempBondsUniq;
	my @TempBonds_GRPH;
	@Temp_Distance_Coords=@$temp_distance_coords;
	while ("@Temp_Distance_Coords" ne '') {
		$GRPH_Atom_Code=shift(@GRPH_Atom_Code);
		$GRPH_Atom_id=shift(@GRPH_Atom_id);
		($X1,$Y1,$Z1)=splice(@Temp_Distance_Coords,0,3);
		@GRPH_Atom_Code_copy=@GRPH_Atom_Code;
		@GRPH_Atom_id_Copy=@GRPH_Atom_id;
		@Temp_Distance_Coords_Copy=@Temp_Distance_Coords;
		while ("@Temp_Distance_Coords_Copy" ne '') {
			$GRPH_Atom_Code_copy=shift(@GRPH_Atom_Code_copy);
			$GRPH_Atom_id_Copy=shift(@GRPH_Atom_id_Copy);
			($X2,$Y2,$Z2)=splice(@Temp_Distance_Coords_Copy,0,3);
			$distance=&distance_calc($X1,$Y1,$Z1,$X2,$Y2,$Z2);
			if ( ($distance >= 1.34 && $distance <= 1.54) || ($distance >= 0.99 && $distance <= 1.29)) {
				#push(@TempBonds_GRPH,$GRPH_Atom_id,$GRPH_Atom_id_Copy);
			}
			else {
				print LOGFILE "$distance   $GRPH_Atom_id   $GRPH_Atom_id_Copy\n";
			}
		}
	}
	#@TempBondsUniq=uniq(@TempBonds_GRPH);
	#@TempAngles_GRPH=&angles(\@TempBondsUniq,\@TempBonds_GRPH);
	#@TempDihedrals_GRPH=&dihedrals(\@TempBondsUniq,\@TempBonds_GRPH);
	return(\@TempBonds_GRPH,\@TempAngles_GRPH,\@TempDihedrals_GRPH,$GRPH_Charge);
	
	#uncomment the commented things if you are using a non mass potential file

}



sub graphene_charge {
	my $cwd;
	my @CWD;
	my $CHARGEFILE=@_[0];
	my $grph_atom_code=@_[1];
	my @GRPH_Atom_Code=@$grph_atom_code;
	my @GRPH_Charge;
	my $Charge_round;
	$CHARGEFILE=~s/_inp.pdb/_Charges/;
	chop $CHARGEFILE;
	#chdir("/home/philip/HomeDir/misc/Charges/$CHARGEFILE/charges") || die "could not open /home/philip/HomeDir/misc/Charges/$CHARGEFILE/charges\n";
	#opendir($cwd,".");
	#@CWD=readdir($cwd);
	#closedir($cwd);
	foreach $file (@CWD) {
		if ($file=~/.*\.csv$/) {
			open(CHARGEFILE,$file);
		}
	}
	while(<CHARGEFILE>) {
		if (/^[0-9]/) {
			@Line=split(/,/,$_);
			$Charge=pop(@Line);
			$Charge=~s/\cM\cJ//;
			$Charge_round=sprintf("%.3f",$Charge);
			push(@GRPH_Charge,$Charge_round);
		}
	}
	map { push(@GRPH_Charge,"0.000") } @GRPH_Atom_Code;
	close(CHARGEFILE);
	return(\@GRPH_Charge);
}



sub data_collector {
	my $TempBondType_ref=shift;
	my $TempAngleType_ref=shift;
	my $TempDihedralType_ref=shift;
	my $TempImproperType_ref=shift;
	my $DATADIR=shift;
	my $atom_mass_code=shift;
	my @atom_mass_code=@$atom_mass_code;
	my $DATAFILE=$DATADIR . '.typ';
	my @TempAngleType_uniq=@$TempAngleType_ref;
	my @TempDihedralType_uniq=@$TempDihedralType_ref;
	my @TempBondType_uniq=@$TempBondType_ref;
	my @TempImproperType_uniq=@$TempImproperType_ref;
	my $a;
	my $b;
	my $c;
	my $d;
	my $j;
	open(DATAFILE,">/home/philip/HomeDir/misc/LAMMPS_Data_Files/$DATADIR/$DATAFILE") || die "unable to open /home/philip/HomeDir/misc/LAMMPS_Data_Files/$DATADIR/$DATAFILE";
	print DATAFILE "ATOMS:\n\n";
	foreach $atom (@atom_mass_code) {
		$j++;
		print DATAFILE "$j	$atom\n";
	}
	print DATAFILE "\n\nBONDS:\n\n";
	foreach $TempBondType_uniq (@TempBondType_uniq) {
		$a++;
		print DATAFILE "$a   $TempBondType_uniq\n";
	}
	print DATAFILE "\n\nANGLES: \n\n";
	foreach $TempAngleType_uniq (@TempAngleType_uniq) {
		$b++;
		print DATAFILE "$b   $TempAngleType_uniq\n";
	}
	print DATAFILE "\n\nDIHEDRALS: \n\n";
	foreach $TempDihedralType_uniq (@TempDihedralType_uniq) {
		$c++;
		print DATAFILE "$c   $TempDihedralType_uniq\n";
	}
	print DATAFILE "\n\nIMPROPERS: \n\n";
	foreach $TempImproperType_uniq (@TempImproperType_uniq) {
		$d++;
		print DATAFILE "$d   $TempImproperType_uniq\n";		
	}
}



sub DPPC_build {
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
			push(@DPPCBondType,@Split_DPPCLINE[5]);
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
			push(@DPPCAngleType,@Split_DPPCLINE[6]);
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
				push(@DPPCDihedralType,@Split_DPPCLINE[8]);
				push(@Dihedral_Numbered,$dihedral_string);
			}
			if (@Split_DPPCLINE[4]==2) {
				push(@PreImproper,@Split_DPPCLINE[0],@Split_DPPCLINE[1],@Split_DPPCLINE[2],@Split_DPPCLINE[3])
			}
		}
	}
	map { push(@TempBonds,$DataStringCreater{$_}) } @PreBond;
	map { push(@TempAngles,$DataStringCreater{$_}) } @PreAngle;
	map { push(@TempDihedrals,$DataStringCreater{$_}) } @PreDihedral;
	map { push(@TempImpropers,$DataStringCreater{$_}) } @PreImproper;
	return(\@TempBonds,\@TempAngles,\@TempDihedrals,\@TempImpropers,\%ChargeCreater,\%DataTypeCreater,\@DPPCBondType,\@DPPCAngleType,\@DPPCDihedralType);
}



sub Param_act {
	my $atomdata_ref = @_[0];
	my %atomdata=%$atomdata_ref;
	my $TempArray_ref = @_[1];
	my $x =@_[3];
	my $WORD=@_[2];
	my $file=@_[4];
	my @TempArray=@$TempArray_ref;
	my $i=0;
	my @split_line;
	my $string_d;
	my @Array_act_temp;
	my @Array_code;
	my @Array_code_temp;
	my $Array_str;
	my @TempArray_uniq;
	my $count;
	my @Array_type_temp;
	my @Array_type;
	my $array;
	my $reversed_array;
	my @Array_code_splice;
	my $arrayX;
	my @repeat;
	my $reversed_arrayX;
	my @Array_Act;
	my $repeat;
	my $Array;
	my @Array_type_uniq;
	my $g;
	my $f;
	my $TempArray_str;
	my $uniqArray;
	my @TempArray_splice;
	my @Array_Act_prep;
	my @Array_Act_pre;
	my @Array_type_out;
	open(DFILE,"$file") || die 'ubale to open .prm file';
	while(<DFILE>) {
		if ( /^\s+$/ && $i == 1) {
			last
		}
		if ( $i == 1 && /^[^!]/ ) {
			$count++;
			@split_line = split(/\s+/,$_);
			for ($f=0;$f<$x-1;$f++) {
				$string_d = $string_d . "@split_line[$f] ";
			}
			$string_d = $string_d . "@split_line[$x-1]"; 
			push(@Array_act_temp,$string_d);
			push(@Array_type_temp,$count);
			undef($string_d);
		}
		if ( /$WORD/ ) {
			$i=1;
		}
	}
	@TempArray_uniq = uniq(@TempArray);
	$TempArray_str = "@TempArray";
	foreach $uniqArray (@TempArray_uniq) {
		$TempArray_str =~ s/\b\Q$uniqArray\E\b/$atomdata{$uniqArray}/g;
	}
	@Array_code_temp = split(/\s+/,$TempArray_str);
	while ("@Array_code_temp" ne '') {
		@TempArray_splice = splice(@TempArray,0,$x);
		@Array_code_splice = splice(@Array_code_temp,0,$x);
		push(@Array_Act_prep,"@TempArray_splice");
		push(@Array_code,"@Array_code_splice");
	}
	foreach $array (@Array_code) {
		$i=0;
		$count=0;
		$arrayX=$array;
		map {
			if ( /^$array$/ ) {
				$i++;
				push(@Array_type,@Array_type_temp[$count]);
			}
			$count++;
		} @Array_act_temp;
		$count=0;
		if ($i == 0) {
			$reversed_array = join(" ", reverse split(" ", $array));
			map {
				if ( /^$reversed_array$/ ) {
					$i++;
					push(@Array_type,@Array_type_temp[$count]);
				}
				$count++;
			} @Array_act_temp;
		$count=0;
		}
		if ( $WORD eq 'DIHEDRALS' ) {
			if ( $i == 0 ) {
				$arrayX =~ s/^[a-zA-Z0-9]* /X /;
				$arrayX =~ s/ [a-zA-Z0-9]*$/ X/;
				map {
					if ( /^$arrayX$/ ) {
						$i++;
						push(@Array_type,@Array_type_temp[$count]);
					}
					$count++;
				} @Array_act_temp;
			$count=0;
			}
			if ( $i== 0 ) {
				$reversed_arrayX = join(" ", reverse split(" ", $arrayX));
				map {
					if ( /^$reversed_arrayX$/ ) {
						$i++;
						push(@Array_type,@Array_type_temp[$count]);
					}
					$count++;
				} @Array_act_temp;
				$count=0;
			}
		}
		if ( $WORD eq 'IMPROPER') {
			if ( $i == 0 ) {
				$arrayX =~ s/ [a-zA-Z0-9]* [a-zA-Z0-9]* / X X /g;
				map {
					if ( /^$arrayX$/ ) {
						$i++;
						push(@Array_type,@Array_type_temp[$count]);
					}
					$count++;
				} @Array_act_temp;
			$count=0;
			}
			if ( $i== 0 ) {
				$reversed_arrayX = join(" ", reverse split(" ", $arrayX));
				map {
					if ( /^$reversed_arrayX$/ ) {
						$i++;
						push(@Array_type,@Array_type_temp[$count]);
					}
					$count++;
				} @Array_act_temp;
				$count=0;
			}
		}  
		push(@repeat,$i);
	}
	foreach $Array (@Array_Act_prep) {
		$repeat=shift(@repeat);
		for($g = 0; $g < $repeat; $g++) {
			push(@Array_Act_pre,$Array);
		}
	}
	foreach $pre_array (@Array_Act_pre) {
		@split_pre_array = split(/\s+/,$pre_array);
		push(@Array_Act,@split_pre_array);
	}
	@Array_type_uniq=uniq(@Array_type);
	foreach $Array_type_uniq (@Array_type_uniq) {
		$z++;
		map { s/\b$Array_type_uniq\b/a$z/g} @Array_type;
		push(@Array_type_out,@Array_act_temp[$Array_type_uniq-1])
	}
	return(\@Array_Act,\@Array_type,\@Array_type_out);
}