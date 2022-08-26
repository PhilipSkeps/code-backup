#!/usr/bin/perl


use File::Spec;
use List::Uniq ':all';
use List::MoreUtils qw(first_index indexes);
use List::Util qw(max min);
use Cwd qw(cwd);
&LAMMPS_data_file_builder;



sub build_from_pdb {
    chdir('/home/pskeps/HomeDir/misc/PDB_Files') || die "could not change directory to PDB_Files";
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
	my @Bond_data_out;
	my @Angle_data_out;
	my @Dihedral_data_out;
	my @Improper_data_out;
	my $Bond_datapre_out;
	my $Angle_datapre_out;
	my $Dihedral_datapre_out;
	my $Improper_datapre_out;
	my @Bond_data_out;
	my @Angle_data_out;
	my @Dihedral_data_out;
	my @Improper_data_out;
	my @Bond_datapre_out;
	my @Angle_datapre_out;
	my @Dihedral_datapre_out;
	my @Improper_datapre_out;
	my $uptick;
	my $Temp_Distance_Coords_ref;
	my $GRPH_Atom_list_ref; 
	my $stop=0;
	my $LJData_Keyed_temp_ref;
	my %LJData_Keyed;
	my $atom_ljdata;
	my $increase=1;
	print "give a pdb file you would like to build a LAMMPS input file for\n";
	$TEMPFILE=<>;
	#$TEMPFILE="Graphene_Flake_21rings_inp.pdb\n";
	chop $TEMPFILE;
	open (FILE, $TEMPFILE) or die "Could not open the $TEMPFILE";
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
            $MoleculeNewLine=substr($PDBLINE,23,4);
			$MoleculeNewLine =~ s/^\s+|\s+$//g;
            if (($MoleculeNewLine ne $MoleculeOldLine && $MoleculeOldLine ne '') || $PDBLINE =~/^END/ || ($MoleculeCodeNew ne $MoleculeCodeOld && $MoleculeCodeOld ne '')) {
				$increase++;
				$percentdone=(($increase/$totallines)*100);
				print "percent done: $percentdone\n";
				push(@TempBondType,@TempBondTypePre);
				push(@TempAngleType,@TempAngleTypePre);
				push(@TempDihedralType,@TempDihedralTypePre);
				push(@TempImproperType,@TempImproperTypePre);
				($TempAtomMassCode_ref,$atomcharge)=&build_data($ChargeData_ref,$AtomData_ref,$TempStringAtomCode);
				($AtomMassCodeTotal_ref)=&atom_mass_code($TempAtomMassCode_ref);
				($TempBondsNumbered_ref,$TempAnglesNumbered_ref,$TempDihedralsNumbered_ref,$TempImpropersNumbered_ref)=&number($TempStringAtomCode,$TempBonds_ref,$TempAngles_ref,$TempDihedrals_ref,$TempImpropers_ref);
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
					($atomtype_numbered,$atom_masses,$atom_mass_code,$atom_ljdata)=&atom_mass_code_numbered($AtomMassCodeTotal_ref,\%LJData_Keyed);
					($bondtype_numbered,$angletype_numbered,$dihedraltype_numbered,$impropertype_numbered,$TempAngleType_uniq,$TempDihedralType_uniq)=&data_type_numbered(\@TempBondType,\@TempAngleType,\@TempDihedralType,\@TempImproperType);
					@BONDTYPE_NUMBERED=@$bondtype_numbered;
					@ANGLETYPE_NUMBERED=@$angletype_numbered;
					@DIHEDRALTYPE_NUMBERED=@$dihedraltype_numbered;
					@IMPROPERTYPE_NUMBERED=@$impropertype_numbered;
					@ATOM_MASSES=@$atom_masses;
					@ATOMTYPE_NUMBERED=@$atomtype_numbered;
					@resi_id_uniq=uniq(@resi_id_all);
					#foreach $resi_id_uniq (@resi_id_uniq) {
						#$count++;
						#map {s/^$resi_id_uniq$/$count/} @resi_id_all;
						#@MOLECULETYPE_NUMBERED=@resi_id_all
					#}
                    last;
                }
            }
			$resi_id_new=substr($PDBLINE,17,4);
			if ($MoleculeCodeOld ne $MoleculeCodeNew && $resi_id_new eq 'GRPH') {
				chdir('/home/pskeps/HomeDir/misc/PDB_Files');
				($Temp_Distance_Coords_ref,$GRPH_Atom_list_ref)=Graphene_Grabber(*PDBFILE,$MoleculeNewLine,$resi_id_new);
				($TempBonds_ref,$TempAngles_ref,$TempDihedrals_ref,$ChargeData_ref,$AtomData_ref,$TempBondTypePre_ref,$TempAngleTypePre_ref,$TempDihedralTypePre_ref,$Bond_typepre_out,$Angle_typepre_out,$Dihedral_typepre_out,$Bond_datapre_out,$Angle_datapre_out,$Dihedral_datapre_out,$LJData_Keyed_temp_ref)=graphene_build($Temp_Distance_Coords_ref,$GRPH_Atom_list_ref);
				@TempBondTypePre = @$TempBondTypePre_ref;
				@TempAngleTypePre = @$TempAngleTypePre_ref;
				@TempDihedralTypePre = @$TempDihedralTypePre_ref;
				my @Bond_typepre_out = @$Bond_typepre_out;
				my @Angle_typepre_out = @$Angle_typepre_out;
				my @Dihedral_typepre_out = @$Dihedral_typepre_out;
				my @Bond_datapre_out = @$Bond_datapre_out;
				my @Angle_datapre_out = @$Angle_datapre_out;
				my @Dihedral_datapre_out = @$Dihedral_datapre_out;
				push(@Bond_data_out,@Bond_datapre_out);
				push(@Angle_data_out,@Angle_datapre_out);
				push(@Dihedral_data_out,@Dihedral_datapre_out);
				push(@Bond_type_out,@Bond_typepre_out);
				push(@Angle_type_out,@Angle_typepre_out);
				push(@Dihedral_type_out,@Dihedral_typepre_out);
				my %LJData_Keyed_temp = %$LJData_Keyed_temp_ref;
				%LJData_Keyed = (%LJData_Keyed,%LJData_Keyed_temp);
				undef($TempImpropers_ref);
				$stop=1;
			}
            $MoleculeOldLine=substr($PDBLINE,23,4);
			$MoleculeOldLine =~ s/^\s+|\s+$//g;
			$MoleculeCodeOld=substr($PDBLINE,21,1);
			if ($resi_id_new ne $resi_id_old && $stop != 1) {
				our $g=0;
				chdir('/home/pskeps/HomeDir/misc/Unpacked-toppar_c36_jul19') || die "Try Running the Script in HomeDir/misc\n";
				($TempBonds_ref,$TempAngles_ref,$TempDihedrals_ref,$TempImpropers_ref,$ChargeData_ref,$AtomData_ref,$TempBondTypePre_ref,$TempAngleTypePre_ref,$TempDihedralTypePre_ref,$TempImproperTypePre_ref,$Bond_typepre_out,$Angle_typepre_out,$Dihedral_typepre_out,$Improper_typepre_out,$Bond_datapre_out,$Angle_datapre_out,$Dihedral_datapre_out,$Improper_datapre_out,$LJData_Keyed_temp_ref)=&driver($resi_id_new);
				@TempBondTypePre = @$TempBondTypePre_ref;
				@TempAngleTypePre = @$TempAngleTypePre_ref;
				@TempDihedralTypePre = @$TempDihedralTypePre_ref;
				@TempImproperTypePre = @$TempImproperTypePre_ref;
				my @Bond_typepre_out = @$Bond_typepre_out;
				my @Angle_typepre_out = @$Angle_typepre_out;
				my @Dihedral_typepre_out = @$Dihedral_typepre_out;
				my @Improper_typepre_out = @$Improper_typepre_out;
				my @Bond_datapre_out = @$Bond_datapre_out;
				my @Angle_datapre_out = @$Angle_datapre_out;
				my @Dihedral_datapre_out = @$Dihedral_datapre_out;
				my @Improper_datapre_out = @$Improper_datapre_out;
				push(@Bond_data_out,@Bond_datapre_out);
				push(@Angle_data_out,@Angle_datapre_out);
				push(@Dihedral_data_out,@Dihedral_datapre_out);
				push(@Improper_data_out,@Improper_datapre_out);
				push(@Bond_type_out,@Bond_typepre_out);
				push(@Angle_type_out,@Angle_typepre_out);
				push(@Dihedral_type_out,@Dihedral_typepre_out);
				push(@Improper_type_out,@Improper_typepre_out);
				my %LJData_Keyed_temp = %$LJData_Keyed_temp_ref;
				%LJData_Keyed = (%LJData_Keyed,%LJData_Keyed_temp);
			}
			$stop=0;
			$resi_id_old=substr($PDBLINE,17,4);	
			if ($TempStringAtomCode eq '') {
				$TempStringAtomCode=substr($PDBLINE,12,4);
			}
			else {
				$TempStringAtomCode=join(' ',$TempStringAtomCode,substr($PDBLINE,12,4));
			}
			push(@MOLECULETYPE_NUMBERED,$increase);
		}
	}
	close(PDBFILE);
	($TOTAL_ATOMS,$TOTAL_BONDS,$TOTAL_ANGLES,$TOTAL_DIHEDRALS,$TOTAL_IMPROPERS)=&total_numbered(\@X,\@BONDS,\@ANGLES,\@DIHEDRALS,\@IMPROPERS);
	@COUNT_ATOMS=(1..$TOTAL_ATOMS);
	@COUNT_BONDS=(1..$TOTAL_BONDS);
	@COUNT_ANGLES=(1..$TOTAL_ANGLES);
	@COUNT_DIHEDRALS=(1..$TOTAL_DIHEDRALS);
	@COUNT_IMPROPERS=(1..$TOTAL_IMPROPERS);
	return(\@X,\@Y,\@Z,\@BONDS,\@ANGLES,\@DIHEDRALS,\@IMPROPERS,\@COUNT_ATOMS,\@COUNT_BONDS,\@COUNT_ANGLES,\@COUNT_DIHEDRALS,\@COUNT_IMPROPERS,$TOTAL_ATOMS,$TOTAL_BONDS,$TOTAL_ANGLES,$TOTAL_DIHEDRALS,$TOTAL_IMPROPERS,\@ATOMCHARGE,\@ATOMTYPE_NUMBERED,\@BONDTYPE_NUMBERED,\@ANGLETYPE_NUMBERED,\@DIHEDRALTYPE_NUMBERED,\@IMPROPERTYPE_NUMBERED,\@MOLECULETYPE_NUMBERED,\@ATOM_MASSES,\@Bond_type_out,\@Angle_type_out,\@Dihedral_type_out,\@Improper_type_out,\@Bond_data_out,\@Angle_data_out,\@Dihedral_data_out,\@Improper_data_out,$atom_mass_code,$atom_ljdata);
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
						#$USERINPUT='y';
						if ( $USERINPUT=~/^[yY]/ ) {
							$i=3;
							($chargedata_ref,$atomdata_ref,$AtomData_list_ref)=&energy_data(*FILE);
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
							($TempBondsnw_ref,$TempBondType_ref,$Bond_type_out,$BondData_out)=&Param_act($atomdata_ref,\@TempBonds,'BONDS',2,$Param_File);
							($TempAnglesnw_ref,$TempAngleType_ref,$Angle_type_out,$AngleData_out)=&Param_act($atomdata_ref,\@TempAngles,'ANGLES',3,$Param_File);
							($TempDihedralsnw_ref,$TempDihedralType_ref,$Dihedral_type_out,$DihedralData_out)=&Param_act($atomdata_ref,\@TempDihedrals,'DIHEDRALS',4,$Param_File);
							($TempImpropersnw_ref,$TempImproperType_ref,$Improper_type_out,$ImproperData_out)=&Param_act($atomdata_ref,\@TempImpropers,'IMPROPER',4,$Param_File);
							($True_ref)=&Dihedral_Cor($TempDihedralsnw_ref,$TempDihedralType_ref);
							($TempDihedralType_ref,$Dihedral_type_out,$DihedralData_out)=&Adjust_Cyclic($True_ref,$TempDihedralType_ref,$Dihedral_type_out,$DihedralData_out);
							($LJData_Keyed_ref)=&Locate_LJ_Data($Param_File,$AtomData_list_ref);
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
	return($TempBondsnw_ref,$TempAnglesnw_ref,$TempDihedralsnw_ref,$TempImpropersnw_ref,$chargedata_ref,$atomdata_ref,$TempBondType_ref,$TempAngleType_ref,$TempDihedralType_ref,$TempImproperType_ref,$Bond_type_out,$Angle_type_out,$Dihedral_type_out,$Improper_type_out,$BondData_out,$AngleData_out,$DihedralData_out,$ImproperData_out,$LJData_Keyed_ref);
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
	my @AtomData_list;
	while(<$file>) {
		if (/^[aA][tT][oO][mM]/) {
			$TempStringData=substr($_,4,21);
			$TempStringData=~s/^\s+|\s+$//g;
			($AtomCode,$DataCode,$Charge)=split(/\s+/,$TempStringData);
			$chargedata{$AtomCode}=$Charge;
			$atomdata{$AtomCode}=$DataCode;
			push(@AtomData_list,$DataCode);
		}
		elsif (/^[bB][oO][nN][dD] |^[dD][oO][uU][bB]/) {
			last;
		}
	}
	return(\%chargedata,\%atomdata,\@AtomData_list);
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
	$TempStringAtomCode=~ s/^\s+|\s+$//g;
	my @TempAtomCode=split(/\s+/,$TempStringAtomCode);
	my @TempBonds= @$TempBonds_ref;
	my @TempAngles= @$TempAngles_ref;
	my @TempDihedrals= @$TempDihedrals_ref;
	my @TempImpropers= @$TempImpropers_ref;
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
	$TempStringAtomCode=~ s/^\s+|\s+$//g;
	my %ChargeData=%$ChargeData_ref;
	my %AtomData=%$AtomData_ref;
	my @TempAtomCode=split(/\s+/,$TempStringAtomCode);
	my @TempAtomCode_copy=@TempAtomCode;
	foreach $AtomCode (@TempAtomCode) {
		map {s/^$AtomCode$/$AtomData{$AtomCode}/} @TempAtomCode_copy;
		$TempStringAtomCode=~s/\b$AtomCode\b/$ChargeData{$AtomCode}/g;
	}
	my @TempAtomCharge=split(/\s+/,$TempStringAtomCode);
	my @TempAtomMassCode=@TempAtomCode_copy;
	push(@ATOMCHARGE,@TempAtomCharge,@GRPH_Charge);
	return(\@TempAtomMassCode,\@ATOMCHARGE);
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
	my $LJData_Keyed_ref=@_[1];
	my %LJData_Keyed=%$LJData_Keyed_ref;
	@AtomMassCodeTotal=@$AtomMassCodeTotal_ref;
	my @TempAtomMass_uniq=uniq(@AtomMassCodeTotal);
	my @ATOM_LJDATA;
	open(MASSFILE,"/home/pskeps/HomeDir/misc/Cleaned_CHARMM_Data/Atom_Mass.prm") || die "could not open .prm file";
	while(<MASSFILE>) {
		@TempStringAtomMass=split(/\s+/,$_);
		$AtomMassValues{@TempStringAtomMass[2]}=@TempStringAtomMass[3];
	}
	close(MASSFILE);
	foreach $TempAtomMass_uniq (@TempAtomMass_uniq) {
		$growth++;
		push(@ATOM_LJDATA,"$growth $LJData_Keyed{$TempAtomMass_uniq}");
		push(@ATOM_MASSES,$TempAtomMass_uniq,$growth);
		map {s/^$TempAtomMass_uniq$/$AtomMassValues{$_}/} @ATOM_MASSES;
		map {s/^$TempAtomMass_uniq$/$growth/} @AtomMassCodeTotal;
	}
	my @ATOMTYPE_NUMBERED=@AtomMassCodeTotal;
	return(\@ATOMTYPE_NUMBERED,\@ATOM_MASSES,\@TempAtomMass_uniq,\@ATOM_LJDATA);
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
	my $atom_ljdata;
	($x,$y,$z,$bonds,$angles,$dihedrals,$impropers,$count_atoms,$count_bonds,$count_angles,$count_dihedrals,$count_impropers,$TOTAL_ATOMS,$TOTAL_BONDS,$TOTAL_ANGLES,$TOTAL_DIHEDRALS,$TOTAL_IMPROPERS,$atomcharge,$atomtype_numbered,$bondtype_numbered,$angletype_numbered,$dihedraltype_numbered,$impropertype_numbered,$moleculetype_numbered,$atom_masses,$TempBondType_ref,$TempAngleType_ref,$TempDihedralType_ref,$TempImproperType_ref,$TempBondData_ref,$TempAngleData_ref,$TempDihedralData_ref,$TempImproperData_ref,$atom_mass_code,$atom_ljdata)=&build_from_pdb;
	&write_data_file($x,$y,$z,$bonds,$angles,$dihedrals,$impropers,$count_atoms,$count_bonds,$count_angles,$count_dihedrals,$count_impropers,$TOTAL_ATOMS,$TOTAL_BONDS,$TOTAL_ANGLES,$TOTAL_DIHEDRALS,$TOTAL_IMPROPERS,$atomcharge,$atomtype_numbered,$bondtype_numbered,$angletype_numbered,$dihedraltype_numbered,$impropertype_numbered,$moleculetype_numbered,$atom_masses,$TempBondType_ref,$TempAngleType_ref,$TempDihedralType_ref,$TempImproperType_ref,$TempBondData_ref,$TempAngleData_ref,$TempDihedralData_ref,$TempImproperData_ref,$atom_mass_code,$atom_ljdata);
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
	my $TempBondData_ref = shift;
	my $TempAngleData_ref = shift;
	my $TempDihedralData_ref = shift;
	my $TempImproperData_ref = shift;
	my $atom_mass_code = shift;
	my $atom_ljdata = shift;
	my @TempBondData=@$TempBondData_ref;
	my @TempAngleData=@$TempAngleData_ref;
	my @TempDihedralData=@$TempDihedralData_ref;
	my @TempImproperData=@$TempImproperData_ref;
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
	my @ATOM_LJDATA=@$atom_ljdata;
	my $i;
	print "what is the name of the soon to be created data file\n";
	$DATAFILE=<>;
	#$DATAFILE='FOOBAR.data';
	chop $DATAFILE;
	$DATADIR=$DATAFILE;
	$DATADIR=~s/\..*//;
	mkdir("/home/pskeps/HomeDir/misc/LAMMPS_Data_Files/$DATADIR");
	chdir("/home/pskeps/HomeDir/misc/LAMMPS_Data_Files/$DATADIR") || die "unable to open ~/HomeDir/LAMMPS_Data_Files/$DATADIR";
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
	print DATAFILE "\nPair Coeffs\n\n";
	foreach $atom_ljdata (@ATOM_LJDATA) {
		print DATAFILE "$atom_ljdata\n";
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
		print DATAFILE "\nBond Coeffs\n\n";
		foreach $TempBondData (@TempBondData) {
			$i++;
			print DATAFILE "$i $TempBondData\n";
		}
		print DATAFILE "\n\n\nBonds\n\n";
		undef($i);
	}
	while ("@BONDS" ne '') {
		$COUNT_BONDS=shift(@COUNT_BONDS);
		$BONDTYPE_NUMBERED=shift(@BONDTYPE_NUMBERED);
		($BOND1,$BOND2)=splice(@BONDS,0,2);
		printf DATAFILE ("%7s $BONDTYPE_NUMBERED %7s %7s\n",$COUNT_BONDS,$BOND1,$BOND2);
	}
	if ("@ANGLES" ne '') {
		print DATAFILE "\nAngle Coeffs\n\n";
		foreach $TempAngleData (@TempAngleData) {
			$i++;
			print DATAFILE "$i $TempAngleData\n";
		}
		print DATAFILE "\n\n\nAngles\n\n";
		undef($i);
	}
	while ("@ANGLES" ne '') {
		$COUNT_ANGLES=shift(@COUNT_ANGLES);
		$ANGLETYPE_NUMBERED=shift(@ANGLETYPE_NUMBERED);
		($ANGLE1,$ANGLE2,$ANGLE3)=splice(@ANGLES,0,3);
		printf DATAFILE ("%7s $ANGLETYPE_NUMBERED %7s %7s %7s\n",$COUNT_ANGLES,$ANGLE1,$ANGLE2,$ANGLE3);
	}
	if ("@DIHEDRALS" ne '') {
		print DATAFILE "\nDihedral Coeffs\n\n";
		foreach $TempDihedralData (@TempDihedralData) {
			$i++;
			print DATAFILE "$i $TempDihedralData\n";
		}
		print DATAFILE "\n\n\nDihedrals\n\n";
		undef($i);
	}
	while ("@DIHEDRALS" ne '') {
		$COUNT_DIHEDRALS=shift(@COUNT_DIHEDRALS);
		$DIHEDRALTYPE_NUMBERED=shift(@DIHEDRALTYPE_NUMBERED);
		($DIHEDRAL1,$DIHEDRAL2,$DIHEDRAL3,$DIHEDRAL4)=splice(@DIHEDRALS,0,4);
		printf DATAFILE ("%7s $DIHEDRALTYPE_NUMBERED %7s %7s %7s %7s\n",$COUNT_DIHEDRALS,$DIHEDRAL1,$DIHEDRAL2,$DIHEDRAL3,$DIHEDRAL4);
	}
	if ("@IMPROPERS" ne '') {
		print DATAFILE "\nImproper Coeffs\n\n";
		foreach $TempImproperData (@TempImproperData) {
			$i++;
			print DATAFILE "$i $TempImproperData\n";
		}
		print DATAFILE "\n\n\nImpropers\n\n";
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
	open(LOGFILE,">/home/pskeps/HomeDir/misc/LAMMPS_Data_Files/file.log") || die "unable to open logfile";
	my $temp_distance_coords=@_[0];
	my $grph_atom_id=@_[1];
	my @GRPH_Atom_id=@$grph_atom_id;
	my $GRPH_Atom_id;
	my $GRPH_Atom_id_Copy;
	my @GRPH_bonds;
	my @Temp_Distance_Coords;
	my $distance;
	my @Temp_Distance_Coords_Copy;
	my @TempBondsUniq;
	my @TempBonds_GRPH;
	my %atomdata;
	my $TempBondsnw_ref;
	my $TempAnglesnw_ref;
	my $TempDihedralsnw_ref;
	my $TempBondType_ref;
	my $TempAngleType_ref;
	my $TempDihedralType_ref;
	my $Bond_type_out;
	my $Angle_type_out;
	my $Dihedral_type_out;
	my %GRPH_Charge;
	my @TempDihedrals_GRPH;
	my $DihedralData_out;
	my $True_ref;
	my @AtomData_list;
	my $file = '/home/pskeps/HomeDir/misc/Unpacked-toppar_c36_jul19/toppar_c36_jul19/par_all36_cgenff.prm';
	foreach $Atom (@GRPH_Atom_id) {
		if ($Atom=~/C/) {
			$atomdata{$Atom} = 'CG2R61';
			$GRPH_Charge{$Atom} = "0.000";
			push(@AtomData_list,'CG2R61');
		}
		else {
			$atomdata{$Atom} = 'HGR61';
			$GRPH_Charge{$Atom} = "0.000";
			push(@AtomData_list,'HGR61');
		}
	}
	@Temp_Distance_Coords=@$temp_distance_coords;
	while ("@Temp_Distance_Coords" ne '') {
		$GRPH_Atom_id=shift(@GRPH_Atom_id);
		($X1,$Y1,$Z1)=splice(@Temp_Distance_Coords,0,3);
		@GRPH_Atom_id_Copy=@GRPH_Atom_id;
		@Temp_Distance_Coords_Copy=@Temp_Distance_Coords;
		while ("@Temp_Distance_Coords_Copy" ne '') {
			$GRPH_Atom_id_Copy=shift(@GRPH_Atom_id_Copy);
			($X2,$Y2,$Z2)=splice(@Temp_Distance_Coords_Copy,0,3);
			$distance=&distance_calc($X1,$Y1,$Z1,$X2,$Y2,$Z2);
			if ( ($distance >= 1.24 && $distance <= 1.57) || ($distance >= 0.70 && $distance <= 1.24)) {
				push(@TempBonds_GRPH,$GRPH_Atom_id,$GRPH_Atom_id_Copy);
			}
			else {
				print LOGFILE "$distance   $GRPH_Atom_id   $GRPH_Atom_id_Copy\n";
			}
		}
	}
	@TempBondsUniq=uniq(@TempBonds_GRPH);
	@TempAngles_GRPH=&angles(\@TempBondsUniq,\@TempBonds_GRPH);
	@TempDihedrals_GRPH=&dihedrals(\@TempBondsUniq,\@TempBonds_GRPH);
	($TempBondsnw_ref,$TempBondType_ref,$Bond_type_out,$BondData_out)=&Param_act(\%atomdata,\@TempBonds_GRPH,'BONDS',2,'/home/pskeps/HomeDir/misc/Unpacked-toppar_c36_jul19/toppar_c36_jul19/par_all36_cgenff.prm','GRPH');
	($TempAnglesnw_ref,$TempAngleType_ref,$Angle_type_out,$AngleData_out)=&Param_act(\%atomdata,\@TempAngles_GRPH,'ANGLES',3,'/home/pskeps/HomeDir/misc/Unpacked-toppar_c36_jul19/toppar_c36_jul19/par_all36_cgenff.prm','GRPH');
	($TempDihedralsnw_ref,$TempDihedralType_ref,$Dihedral_type_out,$DihedralData_out)=&Param_act(\%atomdata,\@TempDihedrals_GRPH,'DIHEDRALS',4,'/home/pskeps/HomeDir/misc/Unpacked-toppar_c36_jul19/toppar_c36_jul19/par_all36_cgenff.prm','GRPH');
	($True_ref)=&Dihedral_Cor($TempDihedralsnw_ref,$TempDihedralType_ref);
	($TempDihedralType_ref,$Dihedral_type_out,$DihedralData_out)=&Adjust_Cyclic($True_ref,$TempDihedralType_ref,$Dihedral_type_out,$DihedralData_out);
	($LJData_Keyed_ref)=&Locate_LJ_Data($file,\@AtomData_list);
	return($TempBondsnw_ref,$TempAnglesnw_ref,$TempDihedralsnw_ref,\%GRPH_Charge,\%atomdata,$TempBondType_ref,$TempAngleType_ref,$TempDihedralType_ref,$Bond_type_out,$Angle_type_out,$Dihedral_type_out,$BondData_out,$AngleData_out,$DihedralData_out,$LJData_Keyed_ref);
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
	open(DATAFILE,">/home/pskeps/HomeDir/misc/LAMMPS_Data_Files/$DATADIR/$DATAFILE") || die "unable to open /home/pskeps/HomeDir/misc/LAMMPS_Data_Files/$DATADIR/$DATAFILE";
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



sub Param_act {
	my $atomdata_ref = @_[0];
	my %atomdata=%$atomdata_ref;
	my $TempArray_ref = @_[1];
	my $x =@_[3];
	my $WORD=@_[2];
	my $file=@_[4];
	my $signal=@_[5];
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
	my $z_grph;
	my $string_n;
	my @Array_Data;
	my @Array_Data_temp;
	my @Array_Data_out;
	if ( $signal eq 'GRPH' ) {
		$check++;
	}
	open(DFILE,"$file") || die 'unable to open .prm file';
	while(<DFILE>) {
		if ( /^\s+$/ && $i == 1) {
			last
		}
		if ( $i == 1 && /^[^!]/ ) {
			$count++;
			@split_line = split(/\s+/,$_);
			for ($f=0;$f<$x;$f++) {
				$string_d = $string_d . "@split_line[$f] ";
			}
			if ($WORD eq 'BONDS') {
				for ($bo=$x;$bo<$x+2;$bo++) {
					$string_n = $string_n . "@split_line[$bo] ";
				}
			}
			if ($WORD eq 'ANGLES') {
				for ($an=$x;$an<$x+4;$an++) {
					if (@split_line[$an] =~ /[a-zA-Z\!]/) {
						@split_line[$an]=0.0000;
					}
					$string_n = $string_n . "@split_line[$an] ";
				}
			}
			if ($WORD eq 'DIHEDRALS') {
				for ($di=$x;$di<$x+3;$di++) {
					if ($x+2==$di) {
						@split_line[$di]=~s/\..*//g;
					}
					$string_n = $string_n . "@split_line[$di] ";
				}
			}
			if ($WORD eq 'IMPROPER') {
				for ($im=$x;$im<$x+3;$im++) {
					if ($im!=$x+1) {
						$string_n = $string_n . "@split_line[$im] ";
					}
				}
			}
			$string_n =~ s/^\s+|\s+$//g;
			$string_d =~ s/^\s+|\s+$//g;
			$string_d_new=$string_d;
			if ($string_d_old eq $string_d_new && $WORD eq 'DIHEDRALS') {
				$string_n= $string_n . ' 0.0';
			}
			elsif($WORD eq 'DIHEDRALS') {
				$string_n= $string_n . ' 1.0';
			}
			$string_d_old=$string_d;
			push(@Array_Data_temp,$string_n); 
			push(@Array_act_temp,$string_d);
			push(@Array_type_temp,$count);
			undef($string_d);
			undef($string_n);
		}
		if ( /^$WORD$/ ) {
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
				push(@Array_Data,@Array_Data_temp[$count]);
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
					push(@Array_Data,@Array_Data_temp[$count]);
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
						push(@Array_Data,@Array_Data_temp[$count]);
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
						push(@Array_Data,@Array_Data_temp[$count]);
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
						push(@Array_Data,@Array_Data_temp[$count]);
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
						push(@Array_Data,@Array_Data_temp[$count]);
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
		if ( $signal eq 'GRPH') {
			map { s/\b$Array_type_uniq\b/b$Array_type_uniq/g} @Array_type;
		}
		else {
			map { s/\b$Array_type_uniq\b/a$z/g} @Array_type;
		}
		if ( $check <= 3 && $signal eq 'GRPH' ) {
			push(@Array_type_out,@Array_act_temp[$Array_type_uniq-1]);
			push(@Array_Data_out,@Array_Data_temp[$Array_type_uniq-1]);
		}
		elsif ($signal ne 'GRPH') {
			push(@Array_type_out,@Array_act_temp[$Array_type_uniq-1]);
			push(@Array_Data_out,@Array_Data_temp[$Array_type_uniq-1]);
		}
	}
	return(\@Array_Act,\@Array_type,\@Array_type_out,\@Array_Data_out);
}



sub Graphene_Grabber {
	my $file = shift;
	my $MoleculeNewLine = shift;
	my $resi = shift;
	my @split_line;
	my $tempstring;
	my $i=1;
	my @Temp_Distance_Coords;
	my $x;
	my $y;
	my $z;
	my $TempStringAtomCode;
	my @GRPH_Atom_list;
	my $saved_position = tell($file);
	{
		do {
			if ( $i > 1 && /Ca / ) {
				last;
			}
			if ( $MoleculeNewLine == 1 && $resi eq 'GRPH' && $_ !~ /END/) {
				@split_line=split(/\s+/,$_);
				($tempstring)=substr($_,30,26);
				$tempstring=~s/^\s+|\s+$//;
				($x,$y,$z)=split(/\s+/,$tempstring);
				push(@Temp_Distance_Coords,$x,$y,$z);
				if ($TempStringAtomCode eq '') {
					$TempStringAtomCode=substr($_,12,4);
				}
				else {
					$TempStringAtomCode=join(' ',$TempStringAtomCode,substr($_,12,4));
				}	
			}
			$i++;
		} while(<$file>);
	} 
	$TempStringAtomCode=~s/^\s+|\s+$//;
	@GRPH_Atom_list=split(/\s+/,$TempStringAtomCode);
	seek($file, $saved_position, 0);
	return(\@Temp_Distance_Coords,\@GRPH_Atom_list);
}



sub Dihedral_Cor {
	my $Dih_Array;
	my $Dih_Array_uncut_ref=shift;
	my $TempDihedralType_ref=shift;
	my @TempDihedralType=@$TempDihedralType_ref;
	my @TempDihedralType_uniq=uniq(@TempDihedralType);
	my %Keyed_True;
	my $TempDihedralType_uniq;
	my $g;
	my $f;
	foreach $TempDihedralType_uniq (@TempDihedralType_uniq) {
		$g++;
		$Keyed_True{$TempDihedralType_uniq}=$g;
	}
	my @Dih_Array_uncut=@$Dih_Array_uncut_ref;
	my $length_Dih_Array_uncut=@Dih_Array_uncut;
	my $A;
	my $B;
	my $C;
	my $D;
	my @True;
	my $Dih_Array_rev;
	my $Dih_Array_cp;
	my $check;
	my $Temp_Dih_Array_ends;
	my $Dih_Array_ends;
	my @Dih_Array;
	my $Type_True;
	for($i=0;$i<$length_Dih_Array_uncut/4;$i++) {
		($A,$B,$C,$D)=splice(@Dih_Array_uncut,0,4);
		push(@Dih_Array,"$A $B $C $D");
	}
	my @Dih_Array_cp=@Dih_Array;
	foreach $Dih_Array (@Dih_Array) {
		$f++;
		$Type_True=@TempDihedralType[$f-1];
		$Dih_Array_cp = shift(@Dih_Array_cp);
		@Dih_Array_cp_split=split(/\s+/,$Dih_Array_cp);
		$Dih_Array_ends="@Dih_Array_cp_split[0] @Dih_Array_cp_split[3]";
		$Dih_Array_rev = join(" ", reverse split(" ", $Dih_Array_ends));
		map {
			@Temp_Dih_Array_cp_split=split(/\s+/,$_);
			$Temp_Dih_Array_ends="@Temp_Dih_Array_cp_split[0] @Temp_Dih_Array_cp_split[3]";
			if ($Dih_Array_ends eq $Temp_Dih_Array_ends && $Dih_Array_cp ne $_) {
				$check=1;
			}
			elsif ($Dih_Array_rev eq $Temp_Dih_Array_ends && $Dih_Array_cp ne $_) {
				$check=1;
			}
		} @Dih_Array;
		if ($check==1) {
			push(@True,$Keyed_True{$Type_True});
		}
		else {
			push(@True,0);
		}
		$check=0;
	}
	return(\@True);
}



sub Adjust_Cyclic {
	my $True_ref=shift;
	my $TempDihedralType_ref=shift;
	my $Dihedral_type_out=shift;
	my $DihedralData_out=shift;
	my @True=@$True_ref;
	my @TempDihedralType=@$TempDihedralType_ref;
	my @Dihedral_type_out=@$Dihedral_type_out;
	my @DihedralData_out=@$DihedralData_out;
	my $i;
	my $g;
	my @TempDihedralType_uniq=uniq(@TempDihedralType);
	my %Keyed_Data;
	my %Keyed_Type;
	my $length_DihedralData_out=@DihedralData_out;
	my $z;
	my @New_Dihedral_type_out;
	my @New_DihedralData_out;
	my $length_TempDihedralType_uniq;
	my $h;
	my $f;
	my @Index_Added;
	my %The_Solver;
	my $Type_replaced;
	my $DihedralData_out;
	my @Type_added;
	foreach $TempDihedralType_uniq (@TempDihedralType_uniq) {
		$g++;
		$Keyed_Data{$TempDihedralType_uniq}=@DihedralData_out[$g-1];
		$Keyed_Type{$TempDihedralType_uniq}=@Dihedral_type_out[$g-1];
	}
	foreach $True (@True) {
		$i++;
		if ($True >= 1) {
			$Type_replaced=@TempDihedralType[$i-1];
			@TempDihedralType[$i-1] = $True . @TempDihedralType[$i-1];
			push(@Type_added,@TempDihedralType[$i-1]);
			$The_Solver{@TempDihedralType[$i-1]}=$Type_replaced;
		}
	}
	my @TempDihedralType_uniq = uniq(@TempDihedralType);
	my @Type_added_uniq = uniq(@Type_added);
	foreach $uniq (@Type_added_uniq) {
		$index= first_index {$_ eq $uniq} @TempDihedralType_uniq;
		push(@Index_Added,$index);
	}
	$length_TempDihedralType_uniq=@TempDihedralType_uniq;
	if ("@Type_added_uniq" ne '' && "@DihedralData_out" ne '') {
		for($h=0;$h<$length_TempDihedralType_uniq;$h++) {
			foreach $Type_Added (@Type_added_uniq) {
				$f++;
				if (@TempDihedralType_uniq[$h] eq $Type_Added) {
					@New_Dihedral_type_out[$h]=$Keyed_Type{$The_Solver{$Type_Added}};
					$DihedralData_out=$Keyed_Data{$The_Solver{$Type_Added}};
					$DihedralData_out=~ s/ 1.0$/ 0.5/g;
					@New_DihedralData_out[$h]=$DihedralData_out;
				}
				else {
					@New_Dihedral_type_out[$h]=$Keyed_Type{@TempDihedralType_uniq[$h]};
					@New_DihedralData_out[$h]=$Keyed_Data{@TempDihedralType_uniq[$h]};
				}
			}
			undef($f);
		}
	}
	else {
		@New_Dihedral_type_out=@Dihedral_type_out;
		@New_DihedralData_out=@DihedralData_out;
	}
	return(\@TempDihedralType,\@New_Dihedral_type_out,\@New_DihedralData_out);
}



sub Locate_LJ_Data {
	my $file = shift;
	my $AtomData_ref = shift;
	my @AtomData = @$AtomData_ref;
	my %LJData_Keyed;
	my $eps;
	my $sig;
	my $eps14;
	my $sig14;
	my $line;
	my @split_line;
	my $i;
	my @AtomData_uniq=uniq(@AtomData);
	open(LJFILE,$file)  || die "unable to open $file";
	while (<LJFILE>) { 
		if ($i==1 && /\s+0\.0*\s+/ && /^[^!]/) {
			foreach $AtomData (@AtomData_uniq) {
				if (/^$AtomData /) {
					$line=$_;
					$line=~s/\!.*//;
					@split_line=split(/\s+/,$line);
					$eps = @split_line[2]*-1;
					$sig = @split_line[3]*2/(2**(1/6));
					$eps14 = @split_line[5]*-1;
					$sig14 = @split_line[6]*2/(2**(1/6));
					if ($eps14 > 0) {
						$LJData_Keyed{$AtomData}= "$eps $sig $eps14 $sig14";
					}
					else {
						$LJData_Keyed{$AtomData}= "$eps $sig $eps $sig";
					}
				}
			}
		}
		if ( /^NONBONDED / ) {
			$i=1;
		}
	}
	return(\%LJData_Keyed);
}