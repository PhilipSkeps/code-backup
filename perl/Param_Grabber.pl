#!/usr/bin/perl

my $bond_type;
my $angle_type;
my $dihedral_type;
my $improper_type;
my $atom_type;
my $atom_type_decipher;
use List::Uniq ':all';

open(OUT,'>/home/philip/HomeDir/misc/PDB_Files/DPPC_Param_File_Water');
chdir('/home/philip/HomeDir/misc/PDB_Files/output_ttree') || die "unable to change the directory";
$bond_coeff='bond_coeff\s+\@bond:g';
$angle_coeff='angle_coeff\s+\@angle:g';
$dihedral_coeff='dihedral_coeff\s+\@dihedral:g';
$improper_coeff='improper_coeff\s+\@improper:g';
($atom_type,$bond_type,$angle_type,$dihedral_type,$improper_type,$mass_type,$atom_type_decipher)=&Data_Grabber;
&Param_Grabber($bond_type,*OUT,$bond_coeff);
&Param_Grabber($angle_type,*OUT,$angle_coeff);
&Param_Grabber($dihedral_type,*OUT,$dihedral_coeff);
&Param_Grabber($improper_type,*OUT,$improper_coeff);
&Pair_Coeff_Grabber($atom_type,*OUT,$atom_type_decipher);
&Mass_Grabber($atom_type,*OUT,$atom_type_decipher);



sub Data_Grabber {
    open(ATOM,'Data Atoms') || die "unable to open Atoms_read";
    while(<ATOM>) {
        @Atom_split=split(/\s+/,$_);
        push(@Atom_type,@Atom_split[2]);  
    }
    close(ATOM);
    open(BOND,'Data Bonds') || die "unable to open Bonds_read";
    while(<BOND>) {
        @Bond_split=split(/\s+/,$_);
        push(@Bond_type,@Bond_split[1]);
    }
    close(BOND);
    open(ANGLE,'Data Angles') || die "unable to open Angles_read";
    while(<ANGLE>) {
        @Angle_split=split(/\s+/,$_);
        push(@Angle_type,@Angle_split[1]);
    }
    close(ANGLE);
    open(DIHEDRALS,'Data Dihedrals') || die "unable to open Dihedrals_read";
    while(<DIHEDRALS>) {
        @Dihedrals_split=split(/\s+/,$_);
        push(@Dihedrals_type,@Dihedrals_split[1]);
    }
    close(DIHEDRALS);
    open(IMPROPERS,'Data Impropers') || die "unable to open Impropers_read";
    while(<IMPROPERS>) {
        @Impropers_split=split(/\s+/,$_);
        push(@Impropers_type,@Impropers_split[1]);
    }
    close(IMPROPERS);
    open(MASS,'Data Masses') || die "unable to open mass_read";
    while(<MASS>) {
        @Mass_split=split(/\s+/,$_);
        push(@Mass_type,@Mass_split[0]);
        $Atom_type_decipher{@Mass_split[0]}=@Mass_split[3];

    }
    @Atom_type_uniq=uniq(@Atom_type);
    foreach $atom_type (@Atom_type_uniq){
        foreach $atom (@Mass_type) {
            if ( $atom == $atom_type ) {
                push(@Mass_uniq,$atom);
            }
        }
    }
    @Bond_type_uniq=uniq(@Bond_type);
    @Angle_type_uniq=uniq(@Angle_type);
    @Dihedrals_type_uniq=uniq(@Dihedrals_type);
    @Impropers_type_uniq=uniq(@Impropers_type);
    return(\@Atom_type_uniq,\@Bond_type_uniq,\@Angle_type_uniq,\@Dihedrals_type_uniq,\@Impropers_type_uniq,\@Mass_uniq,\%Atom_type_decipher);
}



sub Param_Grabber {
    my $type=shift;
    my $out_handle=shift;
    my $line_beginner=shift;
    my @type=@$type;
    open(PARAM,'/home/philip/HomeDir/misc/PDB_Files/DPPC_Param_temp.lt') || die 'unable to read from Param_read';
    while(<PARAM>) {
        $line=$_;
        map {
            if ( $line=~/$line_beginner$_\s+/ ) {
                print $out_handle "$line";
            }
        } @type;
    }
    close(PARAM);
}



sub Pair_Coeff_Grabber {
    my $type=shift;
    my $out_handle=shift;
    my $atom_type_decipher=shift;
    my @type=@$type;
    my $line;
    my @Array;
    my @Array_uniq;
    my %atom_type_decipher=%$atom_type_decipher;
    map { s/$_/$atom_type_decipher{$_}/ } @type;
    open(PARAM,'/home/philip/HomeDir/misc/PDB_Files/DPPC_Param_temp.lt') || die 'unable to read from Param_read';
    while(<PARAM>) {
        $line=$_;
        foreach $fellow (@type) {
            if ( $line=~/pair_coeff\s+\@atom:$fellow|pair_coeff\s+\@atom:[0-9]*\s+\@atom:$fellow/ ) {       
                foreach $Search (@type) {
                    foreach $Atom_type (@type) {
                        if ( $line=~/pair_coeff\s+\@atom:$Search\s+\@atom:$Atom_type\s+|
                            pair_coeff\s+\@atom:$Atom_type\s+\@atom:$Search\s+|
                            pair_coeff\s+\@atom:$Search\s+\@atom:$Search\s+/ ) {
                            push(@Array,$line);
                        }
                    }
                }
            }
        }
    }
    @Array_uniq=uniq(@Array);
    foreach $element (@Array_uniq) {
        print $out_handle "$element";
    }
    close(PARAM);
}



sub Mass_Grabber {
    my $mass_type=shift;
    my $out_handle=shift;
    my $atom_type_decipher=shift;
    my %atom_type_decipher=%$atom_type_decipher;
    my @type=@$mass_type;
    my @type_uniq=uniq(@type);
    map { s/$_/$atom_type_decipher{$_}/ } @type_uniq;
    open(MASS,'/home/philip/HomeDir/misc/PDB_Files/DPPC_Param_temp.lt') || die "unable to open mass_read";
    while(<MASS>) {
        $line=$_;
        if ( $line=~/\Qwrite_once("Data Masses")\E/) {
            $i=1;
        }
        if ( $line=~/^\n$/ && $i==1 ) {
            $i=0;
        }
        if ( $i==1 ) {
            map {
                if ( $line=~/\s+\@atom:$_\s+/ ) {
                    print $out_handle "$line";
                }
            } @type_uniq;
        }
    }
}