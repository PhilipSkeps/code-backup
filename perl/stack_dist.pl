#!/usr/bin/perl

use List::Util qw(sum);

open(FILE,'/home/pskeps/HomeDir/misc/LAMMPS_Result_Files/CoM_zAng_stack.com')  || die 'unable to open you fucko';
while(<FILE>) {
    @split_line = split(/\s+/,$_);
    if(@split_line[2]==290000) {
        $i=1;
    }
    if($i==1) {
        $Difference = (@split_line[1]-@split_line[0]);
        push(@Difference,$Difference);
    }
}

$Average=&Average(\@Difference);
print "Average stack distance:   $Average\n";

sub Average {
    my $Array=shift;
    my @Array=@$Array;
    my $Total=sum(@Array); 
    my $length_Array=@Array;
    my $Average=$Total/$length_Array;
    return($Average);
}
