#!/usr/bin/perl

use File::Spec;
use List::Uniq ':all';

our $g=0;
sub driver {
	my $nonbondeddata=@_[8];
	my $improperdata=@_[7];
	my $dihedraldata=@_[6];
	my $angledata=@_[5];
	my $bonddata=@_[4];
	my $atommass=@_[3];
	my $imprinfo=@_[2];
	my $atominfo=@_[1];
	my $bondinfo=@_[0];
	my $file;
    opendir($cwd,".");
    local(@directory)=readdir($cwd);
    closedir($cwd);
	foreach $file (@directory) {
		if ( -d $file && $file ne "." && $file ne ".."){
			chdir($file);
			&driver;
			chdir("..") || die "oh god\n";
		}
		elsif ( -T $file ) {
			&atom_info($file,$atominfo);
			&bond_info($file,$bondinfo);
			&impr_info($file,$imprinfo);
			&mass_data($file,$atommass);
			&bond_data($file,$bonddata);
			&angle_data($file,$angledata);
			&dihedral_data($file,$dihedraldata);
			&improper_data($file,$improperdata);
			&nonbonded_data($file,$nonbondeddata);
        }
	}
}



sub bond_info {
	my $file=@_[0];
	my $bondinfo=@_[1];
	my $i=0;
	open(FILE,$file) || die "could not open the txt file";
	while (<FILE>) {
		if (/^[rR][eE][sS][iI] /) {
			$i=1;
			print $bondinfo "$_";
			print $bondinfo File::Spec->rel2abs($file) . "\n";
		}
		if (/^[bB][oO][nN][dD] |^[dD][oO][uU][bB]/ && ($i==1 || $i==2)) {
			s/\!.*[^\n]//s;
			s/\'/ /g;
			print $bondinfo $_;
			$i=2;
		}
		if (/^[^bB][^oO][^nN][^dD] |^[^dD][^oO][^uU][^bB]/ && $i==2) {
			$i=0;
			print $bondinfo "END\n\n";
		}
	}
	close(FILE);
}



sub atom_info {
	my $file=@_[0];
	my $atominfo=@_[1];
	my $i=0;
	open(FILE,$file) || die "could not open the txt file";
	while (<FILE>) {
		if (/^[rR][eE][sS][iI] /) {
			$i=1;
			print $atominfo "$_";
			print $atominfo File::Spec->rel2abs($file) . "\n";
		}
		if (/^[aA][tT][oO][mM] / && ($i==1 || $i==2)) {
			s/\!.*[^\n]//s;
			print $atominfo $_;
			$i=2;
		}
		if (/^[^aA][^tT][^oO][^mM] / && /^[^gG][^rR][^oO][^uU][^pP]/ && /^[^\s+]/ && $i==2) {
			$i=0;
			print $atominfo "END\n\n";
		}
	}
	close(FILE);
}



sub impr_info {
	my $file=@_[0];
	my $imprinfo=@_[1];
	my $i=0;
	open(FILE,$file) || die "could not open the txt file";
	while (<FILE>) {
		if (/^[rR][eE][sS][iI] /) {
			$i=1;
			print $imprinfo "$_";
			print $imprinfo File::Spec->rel2abs($file) . "\n";
		}
		if (/^[iI][mM][pP][rRhH]/ && ($i==1 || $i==2)) {
			s/\!.*[^\n]//s;
			s/\'/ /g;
			print $imprinfo $_;
			$i=2;
		}
		if (/^[^iI][^mM][^pP][^rRhH]/ && $i==2) {
			$i=0;
			print $imprinfo "END\n\n";
		}
	}
	close(FILE);
}



sub mass_data {
	my $file=@_[0];
	my $atommass=@_[1];
	my $i;
	open(FILE,$file) || die "could not open the txt file";
	while (<FILE>) {
		$i=1;
		if (/^MASS/) {
			@massline=split(/\s+/,$_);
			$data_code=@massline[2];
			@uniq_data_code=uniq(@data_code);
			map { 
				if (/$data_code/) {
					$i=0;
				}
			} @uniq_data_code;
			if ($i==1) {
				push(@data_code,$data_code);
				print $atommass $_;
			}
		}
	}
	close(FILE);
}



sub bond_data {
	my $file=@_[0];
	my $bonddata=@_[1];
	my $i;
	open(FILE,$file) || die "could not open txt file";
	while(<FILE>) {
		if (/^BONDS/) {
			print $bonddata "\n\n" . File::Spec->rel2abs($file) . "\n";
			$i=1
		}
		elsif (/^ANGLES/) {
			$i=0
		}
		if ($i==1) {
			print $bonddata $_;
		}
	}
}



sub angle_data {
	my $file=@_[0];
	my $angledata=@_[1];
	my $i;
	open(FILE,$file) || die "could not open txt file";
	while(<FILE>) {
		if (/^ANGLES/) {
			print $angledata "\n\n" . File::Spec->rel2abs($file) . "\n";
			$i=1
		}
		elsif (/^DIHEDRALS/) {
			$i=0
		}
		if ($i==1) {
			print $angledata $_;
		}
	}
}



sub dihedral_data {
	my $file=@_[0];
	my $dihedraldata=@_[1];
	my $i;
	open(FILE,$file) || die "could not open txt file";
	while(<FILE>) {
		if (/^DIHEDRALS/) {
			print $dihedraldata "\n\n" . File::Spec->rel2abs($file) . "\n";
			$i=1
		}
		elsif (/^IMPROPER/) {
			$i=0
		}
		if ($i==1) {
			print $dihedraldata $_;
		}
	}
}



sub improper_data {
	my $file=@_[0];
	my $improperdata=@_[1];
	my $i;
	open(FILE,$file) || die "could not open txt file";
	while(<FILE>) {
		if (/^IMPROPER/) {
			print $improperdata "\n\n" . File::Spec->rel2abs($file) . "\n";
			$i=1
		}
		elsif (/^NONBONDED/) {
			$i=0
		}
		if ($i==1) {
			print $improperdata $_;
		}
	}
}



sub nonbonded_data {
	my $file=@_[0];
	my $nonbondeddata=@_[1];
	my $i;
	open(FILE,$file) || die "could not open txt file";
	while(<FILE>) {
		if (/^NONBONDED/) {
			print $nonbondeddata "\n\n" . File::Spec->rel2abs($file) . "\n";
			$i=1
		}
		elsif (/^END/) {
			$i=0
		}
		if ($i==1) {
			print $nonbondeddata $_;
		}
	}
}



open(BONDINFO,">/home/philip/HomeDir/misc/Cleaned_CHARMM_Data/Bond_Info.rtf") || die " could not open Bond_Info.rtf\n";
open(ATOMINFO,">/home/philip/HomeDir/misc/Cleaned_CHARMM_Data/Atom_Info.rtf") || die " could not open Atom_Info.rtf\n";
open(IMPRINFO,">/home/philip/HomeDir/misc/Cleaned_CHARMM_Data/Impr_Info.rtf") || die " could not open Impr_Info.rtf\n";
open(ATOMMASS,">/home/philip/HomeDir/misc/Cleaned_CHARMM_Data/Atom_Mass.prm") || die " could not open Atom_Mass.prm\n";
open(BONDDATA,">/home/philip/HomeDir/misc/Cleaned_CHARMM_Data/Bond_Data.prm") || die " could not open Bond_Data.prm\n";
open(ANGLEDATA,">/home/philip/HomeDir/misc/Cleaned_CHARMM_Data/Angle_Data.prm") || die " could not open Angle_Data.prm\n";
open(DIHEDRALDATA,">/home/philip/HomeDir/misc/Cleaned_CHARMM_Data/Dihedral_Data.prm") || die " could not open Dihedral_Data.prm\n";
open(IMPROPERDATA,">/home/philip/HomeDir/misc/Cleaned_CHARMM_Data/Improper_Data.prm") || die " could not open Improper_Data.prm\n";
open(NONBONDEDDATA,">/home/philip/HomeDir/misc/Cleaned_CHARMM_Data/Nonbonded_Data.prm") || die " could not open Nonbonded_Data.prm\n";
chdir('/home/philip/HomeDir/misc/Unpacked-toppar_c36_jul19') || die "Try Running the Script in HomeDir/misc\n";
&driver(*BONDINFO,*ATOMINFO,*IMPRINFO,*ATOMMASS,*BONDDATA,*ANGLEDATA,*DIHEDRALDATA,*IMPROPERDATA,*NONBONDEDDATA);
close(BONDINFO);
close(ATOMINFO);
close(IMPRINFO);
close(ATOMMASS);
close(BONDDATA);