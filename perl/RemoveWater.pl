#!/usr/bin/perl

open(FILE,'/home/philip/HomeDir/misc/PDB_Files/DPPC_Bilayer_temp_test.pdb') || die "you fucked up\n";
open(OUT,'>/home/philip/HomeDir/misc/PDB_Files/DPPC_BilayerC.pdb') || die "hebby";
while(<FILE>) {
    if(/HETATM/) {
        @line_split=split(/\s+/,$_);
        $ZCoord=substr($_,46,8);
        $ZCoord=~s/^\s+|\s+$//g;
        push(@Molecule_Z,$ZCoord);
        $mol_id_old=$mol_id;
        $mol_id=substr($_,22,4);
        $mol_id=~s/^\s+|\s+$//g;
        $mol_id_new=$mol_id;
        if($mol_id_old == $mol_id_new || $mol_id_old eq '') {
            push(@Molecule_col,$_);
        }
        else {
            foreach $Molecule_Z_code (@Molecule_Z) {
                if ($Molecule_Z_code <= 47.09 && $Molecule_Z_code >= 15.09) {
                    $i=1;
                }
            }
            if( $i==0 ) {
                foreach $Molecule_col (@Molecule_col) {
                    print OUT "$Molecule_col";
                }
            }
            $i=0;
            undef(@Molecule_Z);
            undef(@Molecule_col);
            push(@Molecule_col,$_);
        }
    }
    else {
        print OUT $_;
    }
}