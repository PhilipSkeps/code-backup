#!/usr/bin/perl

use File::Spec;

our $g=0;
sub atom_code_search {
    my $TEMPMOLECULE=@_[0];
    my $i=0;
	my $file;
    opendir($cwd,".");
    local(@directory)=readdir($cwd);
    closedir($cwd);
	foreach $file (@directory) {
		if ( -d $file && $file ne "." && $file ne ".."){
			chdir($file);
			&atom_code_search;
			chdir("..") || die "oh god\n";
		}
		elsif ( -T $file ){
			open(FILE,$file) || die "could not open the txt file";
			while(<FILE>){
				if (/^[rR][eE][sS][iI]/ && $i==1){
					$i=0;
				}
				if (/\s*$TEMPMOLECULE[\s*,]/ && $i==0){
					$i=1;
				}
				if (/^[rR][eE][sS][iI][ ](.{4,7})[ ]/ && $i==1) {
					print "\n$_\nin $file\n";
					print File::Spec->rel2abs($file) . "\n";
					while(1==1) {	
						print "is this correct (y/n)\n";
						$USERINPUT=<>;
						if ( $USERINPUT=~/^[yY]/ ) {
                            $Atom_Code=substr($_,4,6);
							$g=1;
							last;
						}
						elsif ( $USERINPUT=~/[nN]/ ){
							last;
						}
						else {
							print "Invalid input try again\n";
							next;
						}
					}
				}
				if ($g==1) {
					last;
				}
            $i=0;
            }
        }
		if ( $g==1 ) {
			last;
		}
    }
    return $Atom_Code;
}

chdir('/home/philip/HomeDir/misc/Unpacked-toppar_c36_jul19') || die "Try Running the Script in HomeDir/misc\n";
print "what molecule do you need the code for\n";
$TEMPMOLECULE=<>;
chop $TEMPMOLECULE;
$Atom_Code=&atom_code_search($TEMPMOLECULE);
print "\nthe Atom Code is $Atom_Code\n\n";