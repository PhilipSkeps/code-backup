#!/usr/bin/perl

use List::MoreUtils qw(first_index indexes);


chdir('/home/philip/HomeDir/misc/LAMMPS_Data_Files/test') || die 'unable to move';
open(AFILE,"compare.ang") || die 'unable to open AFILE';
open(DFILE,"compare.dih") || die 'unable to open DFILE';
open(TAFILE,"test.ang") || die 'unable to open TAFILE';
open(TDFILE,"test.dih") || die 'unable to open TDFILE';
while(<AFILE>) {
    @lineA=split(/\s+/,$_);
    push(@Angle_Data,@lineA[2],@lineA[3],@lineA[4]);
}
while(<DFILE>) {
    @lineD=split(/\s+/,$_);
    push(@Dihedral_Data,@lineD[2],@lineD[3],@lineD[4],@lineD[5]);
}
while(<TAFILE>) {
    @lineTA=split(/\s+/,$_);
    push (@Angle_Test_Data,@lineTA[2],@lineTA[3],@lineTA[4]);
}
while(<TDFILE>) {
    @lineTD=split(/\s+/,$_);
    push(@Dihedral_Test_Data,@lineTD[2],@lineTD[3],@lineTD[4],@lineTD[5]);
}

($Angle_Extra_List_ref,$Angle_Missing_List_ref)=Check_data(\@Angle_Data,\@Angle_Test_Data,3);
($Dihedral_Extra_List_ref,$Dihedral_Missing_List_ref)=Check_data(\@Dihedral_Data,\@Dihedral_Test_Data,4);

print "These are Extra Angles:\n\n";
print_ts($Angle_Extra_List_ref,3);

print "\n\nYou are Missing These Angles:\n\n";
print_ts($Angle_Missing_List_ref,3);

print "\n\nThese are Extra Dihedrals:\n\n";
print_ts($Dihedral_Extra_List_ref,4);

print "\n\nYou are Missing These Dihedrals:\n\n";
print_ts($Dihedral_Missing_List_ref,4);

sub Check_data {
    my $array=shift;
    my $Array_Test_Data=shift;
    my $x=shift;
    my @Array=@$array;
    my @Array_Test_Data=@$Array_Test_Data;
    my @Array_Data_st;
    my @EXTRA_LIST;
    my @MISSING_LIST;
    while("@Array" ne '') {
        @Array_Data_sub=splice(@Array,0,$x);
        push(@Array_Data_st,"@Array_Data_sub");
    }
    @EXTRA_LIST = @Array_Data_st;
    while ("@Array_Test_Data" ne '') {
        $i=0;
        @Array_Test_Data_sub=splice(@Array_Test_Data,0,$x);
        foreach $data (@Array_Data_st) {
            if ("@Array_Test_Data_sub" eq "$data") {
                $i=1;
                $index = first_index { $_ eq "@Array_Test_Data_sub" } @EXTRA_LIST;
                splice(@EXTRA_LIST,$index,1);
                last;
            }
        }
        if ($i == 0) {
            @Array_Test_Data_subrev = reverse @Array_Test_Data_sub;
            foreach $string (@Array_Data_st) {
                if ("@Array_Test_Data_subrev" eq $string) {
                    $i=1;
                    $index = first_index { $_ eq "@Array_Test_Data_subrev" } @EXTRA_LIST;
                    splice(@EXTRA_LIST,$index,1);
                    last;
                }
            }
        }
        if ($i == 0) {
            push(@MISSING_LIST,"@Array_Test_Data_sub");
        }
    }
    return(\@EXTRA_LIST,\@MISSING_LIST);
}

sub print_ts {
    my $ARRAY = shift;
    my $X = shift;
    my @ARRAY= @$ARRAY;
    while ("@ARRAY"  ne '') {
        @Print=shift(@ARRAY);
        print "@Print \n";
    }
}