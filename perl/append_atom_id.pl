#!/usr/bin/perl

my $count=0;
my $check;
my $first_piece;
my $second_piece;
open(FILE, "<-") || die "could not open the pdb file try using the \"\<\" to input a pdb file";
open(COPY, ">-") || die "could not open the pdb file try using the \"\>\" to output to a pdb file";
while (<FILE>) {
    if (/^HETATM/ || /^ATOM/ || /^TER/ || /^HELIX/ || /^SHEET/ || /^SSBOND/) {
        $count++;
        if ($count < 10) {
            $count=$count . '  ';
        }
        elsif ($count < 100 && $count >= 10) {
            $count=$count . ' ';
        }
        $first_piece=substr($_,0,17);
        $check=substr($_,17,3);
        $second_piece=substr($_,20);
        if ($check eq "   ") {
            print COPY "$first_piece$count$second_piece";
        }
        else {
            $_=~s/UNK|MOL|METH|DPP/$count/;
            print COPY $_;
        }
    }
    else {
        print COPY $_;
    }
}
close(FILE);
close(COPY);