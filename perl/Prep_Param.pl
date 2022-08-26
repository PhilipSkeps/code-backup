#!/usr/bin/perl

my %ID_Num;
my @Pre_out;
use List::Uniq ':all';
push(@Pre_out,dummy);
#chdir('/home/philip/HomeDir/misc/LAMMPS_Data_Files/DPPC_Water_test');
opendir(DIR,".") || die "unable to open working directory";
open(OUT,'>copy_paste.prm') || die "Fuck You";
@WorkingDirectory = readdir(DIR);
closedir(DIR);
map {
    if (/.*\.typ/) {
        open(IDFILE,$_) || die "unable to open $_ if this is not a \.typ file try running in a directory who contains one";  
    }
} @WorkingDirectory;
while(<IDFILE>) {
    if ( /ATOMS/ ) {
        $i=1;
    }
    if ( $i==1 && /^[0-9]/ ) {
        @split_line=split(/\s+/,$_);
        push(@AtomID,@split_line[1]);
        $ID_Num{@split_line[1]}=@split_line[0];
    }
    if ( /BOND/ ) {
        $i=0;
    }
}
close(IDFILE);
open(PFILE,'/home/philip/HomeDir/misc/LAMMPS_Data_Files/DPPC_test/DPPC_test.top') || die 'unable to open the whore';
while(<PFILE>) {
    $line=$_;
    map {
        if ( $line=~/$_/ ) {
            map {
                $line=~s/\b$_\b/$ID_Num{$_}/g;
            } @AtomID;
            if ( $line=~/^[^aA-zZ]*$/ ) {
                @split_line=split(/\s+/,$line);
                $firstsymbol=shift(@split_line);
                $secondsymbol=shift(@split_line);
                $string="pair_coeff " . "$firstsymbol $secondsymbol " . "lj/cut/coul/long " . "@split_line ";
                if ( $firstsymbol < $secondsymbol ) {
                    $string="pair_coeff " . "$firstsymbol $secondsymbol " . "@split_line";
                    #$string="pair_coeff " . "$firstsymbol $secondsymbol " . "lj/cut/coul/long " . "@split_line ";
                }
                else {
                    $string="pair_coeff " . "$secondsymbol $firstsymbol " . "@split_line";
                    #$string="pair_coeff " . "$secondsymbol $firstsymbol " . "lj/cut/coul/long " . "@split_line ";
                }
                push(@Pre_out,$string);
            }
        }
    } @AtomID;
}
@uniq_Pre_out=uniq(@Pre_out);
while("@uniq_Pre_out" ne ''){
    $string=shift(@uniq_Pre_out);
    print OUT "$string\n";
}
#open(TFILE,'/home/philip/HomeDir/misc/DPPC_test/DPPC_test.typ') || die 'holy mother of god';
while(<TFILE>) {
    $line=$_;
    @Top_Data_temp=split(/\s+/,$_);
    map {
        if ( /^[-0-9\.]*$/ ) {
            push(@Data,$_);
        }
    } @Top_Data_temp;
    if ( $line=~/BONDS/ ) {
        $g=1;
        undef(@Data);
    }
    if ( $line=~/ANGLES/ ) {
        $g=2;
        undef(@Data);
    }
    if ( $line=~/DIHEDRALS/ ) {
        $g=3;
        undef(@Data);
    }
    if ( $line=~/IMPROPERS/ ) {
        $g=4;
        undef(@Data);
    }
    if ( $g==1 && "@Data" ne '') {
        print OUT "bond_coeff @Data\n";
        undef(@Data);
    }
    if ( $g==2 && "@Data" ne '') {
        print OUT "angle_coeff @Data\n";
        undef(@Data);
    }
    if ( $g==3 && "@Data" ne '') {
        $length=@Data;
        if ( $length > 4 ) {
            print OUT "dihedral_coeff nharmonic @Data\n";
            undef(@Data);
        }
        else {
            push(@Data,'0.0');
            print OUT "dihedral_coeff charmm @Data\n";
            undef(@Data);
        }
    }
    if ( $g==4 && "@Data" ne '') {
        print OUT "improper_coeff @Data\n";
        undef(@Data);
    }
}