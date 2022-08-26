#!/usr/bin/perl

print "What file do you wnat me to remove half of:  ";
$FILE=<>;
chop $FILE;
#$FILE='/home/pskeps/HomeDir/misc/PDB_Files/test.pdb';
open(FILE,$FILE) || die "unable to open $FILE";
$FILE =~ s/\..*/_chop.pdb/;
open(OUT,'>',"$FILE") || die "unable to open $FILE";
while(<FILE>) {
    if ($_ !~ /^ATOM|^END|^TER/) {
        print OUT $_;
    }
    elsif ($_ !~ /^TER/) {
        @split_line = split(/\s+/,$_);
        $new_molecule_code = @split_line[4];
        if ( ($new_molecule_code ne $old_molecule_code && $old_molecule_code ne '') || $_ =~ /^END/ ) {
            $i=1;
            while ("@Z" ne '') {
                $Z = shift @Z;
                if ($i == 0) {
                    last;
                }
                if ( $Z < 0 ) {
                    $i=0;
                }
            }
            if ($i==1) { 
                while ("@line" ne '') { 
                    $line = shift @line;
                    print OUT $line;
                }
            }
            undef(@line);
            undef(@Z);
        }
        $old_molecule_code = $new_molecule_code;
        push(@line,$_);
        push(@Z,@split_line[7]);
    }
}
print OUT 'END';
print "Your File is $FILE\n";