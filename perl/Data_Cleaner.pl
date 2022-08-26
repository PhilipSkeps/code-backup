#!/usr/bin/perl
use List::Util qw(sum);

my @DATA;
my @ARRAY;
my @NARRAY;
my $f;
my $h;
chdir('/home/philip/HomeDir/misc/LAMMPS_Result_Files') || die 'unable to chdir';
print 'give me a file to clean: ';
$FILE = <>;
chop $FILE;
print 'Average every this many times: ';
$I = <>;
chop $I;
open(FILE,"$FILE") || die "unable to open $FILE";
$FILE =~ s/\.sim//;
$OUT = "$FILE" . '_Clean.sim';
open(OUT,">$OUT") || die "unable to open $OUT";
while(<FILE>) {
    if ($_ !~ /[A-Za-z]/) {
        push(@DATA,$_);
        @split_line=split(/\s+/,$_);
        $COLUMNS=@split_line;
    }
    else {
        print OUT $_;
    }
}
for($i=0;$i<$COLUMNS;$i++) {
    foreach $DATA (@DATA) {
        $count++;
        @split_line=split(/\s+/,$DATA);
        push(@ARRAY,@split_line[$i]);
        if ($count % $I == 0) {
            if ($i==0) {
                push(@NARRAY,@ARRAY[-1]);
                $total=($count/$I);
            }
            else {
                $AVE_VAL=sum(@ARRAY)/@ARRAY;
                push(@NARRAY,$AVE_VAL);
            }
            undef(@ARRAY);
        }
    }
}
for($g=0;$g<$total;$g++) {
    for($x=0;$x<$COLUMNS;$x++) {
        $h=($g+$x*$total);
        if ($x == ($COLUMNS-1)) {
            print OUT "@NARRAY[$h]\n";
        }
        else {
            print OUT "@NARRAY[$h] ";
        }
    }
}


