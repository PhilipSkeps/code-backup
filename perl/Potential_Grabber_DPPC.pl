#!/usr/bin/perl


($bond_co_ref, $angle_co_ref,
$dihedral_co_ref, $improper_co_ref,
$bond_ref, $angle_ref,
$dihedral_ref, $improper_ref)=&collect_data;

($bond_co_real_ref)=&real_numbers($bond_co_ref);
($angle_co_real_ref)=&real_numbers($angle_co_ref);
($improper_co_real_ref)=&real_numbers($improper_co_ref);
($bond_co_con_ref)=&convert_units_bond($bond_co_real_ref);
($angle_co_con_ref)=&convert_units_angle($angle_co_real_ref);
($dihedral_co_con_ref)=&convert_units_dihedral($dihedral_co_ref);
($improper_co_con_ref)=&convert_units_angle($improper_co_real_ref);

&write_out($bond_co_con_ref,$angle_co_con_ref,$dihedral_co_con_ref,$improper_co_con_ref,$bond_ref,$angle_ref,$dihedral_ref,$improper_ref);


sub collect_data {
    my @Bond_Co;
    my @Angle_Co;
    my @Dihedral_Co;
    my @Improper_Co;
    my @PreBond;
    my @PreAngle;
    my @PreDihedral;
    my @PreImproper;
    my %DataStringCreater;
    open(DPPCFILE,'/home/philip/Documents/dppc.itp') || die "unable to open dppc.itp";
    while(<DPPCFILE>) {
        if (/\s+DPPC\s+/) {
			$_ =~ s/^\s+|\s+$//;
			@Split_DPPCLINE=split(/\s+/,$_);
			$DataStringCreater{@Split_DPPCLINE[0]} = @Split_DPPCLINE[1];
            $DataStringCreater{@Split_DPPCLINE[0]}
		}
        if (/\[ bonds \]/) {
            $i=1;
        }
        if (/^\n$/) {
            $i=0;
        }
        if ($i==1 && /^\s+/) {
            $_ =~ s/^\s+|\s+$//;
            @Split_DPPCLINE=split(/\s+/,$_);
            push(@PreBond,@Split_DPPCLINE[0],@Split_DPPCLINE[1]);
            push(@Bond_Co,@Split_DPPCLINE[3],@Split_DPPCLINE[4]);
        }
        if (/\[ angles \]/) {
            $d=1;
        }
        if (/^\n$/) {
            $d=0;
        }
        if ($d==1 && /^\s+/) {
            $_ =~ s/^\s+|\s+$//;
            @Split_DPPCLINE=split(/\s+/,$_);
            push(@PreAngle,@Split_DPPCLINE[0],@Split_DPPCLINE[1],@Split_DPPCLINE[2]);
            push(@Angle_Co,@Split_DPPCLINE[4],@Split_DPPCLINE[5]);
        }
        if (/\[ dihedrals \]/) {
            $g=1;
        }
        if (/^\n$/) {
            $g=0;
        }
        if ($g==1) {
            $_ =~ s/^\s+|\s+$//;
            @Split_DPPCLINE=split(/\s+/,$_);
            if (@Split_DPPCLINE[4]==1) {
                push(@PreDihedral,@Split_DPPCLINE[0],@Split_DPPCLINE[1],@Split_DPPCLINE[2],@Split_DPPCLINE[3]);
                push(@Dihedral_Co,@Split_DPPCLINE[5],@Split_DPPCLINE[6],@Split_DPPCLINE[7]);
            }
            if (@Split_DPPCLINE[4]==2) {
                push(@PreImproper,@Split_DPPCLINE[0],@Split_DPPCLINE[1],@Split_DPPCLINE[2],@Split_DPPCLINE[3]);
                push(@Improper_Co,@Split_DPPCLINE[5],@Split_DPPCLINE[6]);
            }
        }
    }
    map { s/\Q$_\E/$DataStringCreater{$_}/ } @PreBond;
    map { s/\Q$_\E/$DataStringCreater{$_}/ } @PreAngle;
    map { s/\Q$_\E/$DataStringCreater{$_}/ } @PreDihedral;
    map { s/\Q$_\E/$DataStringCreater{$_}/ } @PreImproper;
    close(DPPC);
    return(\@Bond_Co,\@Angle_Co,\@Dihedral_Co,\@Improper_Co,\@PreBond,\@PreAngle,\@PreDihedral,\@PreImproper);
}



sub real_numbers {
    my $array_ref = shift;
    my @array = @$array_ref;
    map{
        if ($_ =~ /([0-9]\.[0-9]*)E\+([0-9]*)/) {
            $decimal = $1;
            $exponent = $2;
        }
        $evaluated = ($decimal*10**$exponent);
        s/\Q$_\E/$evaluated/;
    } @array;
    return(\@array);
}



sub convert_units_bond {
    my $array_ref = shift;
    my @array = @$array_ref;
    my $count;
    my $converted;
    map {
        $count++;
        if ( $count % 2 == 1 ) {
            $converted = $_ * 10;
        }
        else {
            $converted = (($_ * 1.0364*10**-2)/(100))
        }
        s/\Q$_\E/$converted/;
    } @array;
    return(\@array);
}



sub convert_units_angle {
    my $array_ref = shift;
    my @array = @$array_ref;
    my $count;
    my $converted;
    map {
        $count++;
        if ( ($count % 2) == 0 ) {
            $converted = ($_ * 1.0364*10**-2);
            s/\Q$_\E/$converted/;
        }
    } @array;
    return(\@array);
}



sub convert_units_dihedral {
    my $array_ref = shift;
    my @array = @$array_ref;
    my $count;
    my $converted;
    map {
        $count++;
        if ( ($count % 3) == 2 ) {
            $converted = ($_ * 1.0364*10**-2);
            s/\Q$_\E/$converted/;
        }
    } @array;
    return(\@array);
}



sub write_out {
    my $bond_co_con_ref = shift;
    my $angle_co_con_ref = shift;
    my $dihedral_co_con_ref = shift;
    my $improper_co_con_ref = shift;
    my $bond_ref = shift;
    my $angle_ref = shift;
    my $dihedral_ref = shift;
    my $improper_ref = shift;
    my @Bond_Con_Co = @$bond_co_con_ref;
    my @Angle_Con_Co = @$angle_co_con_ref;
    my @Dihedral_Con_Co = @$dihedral_co_con_ref;
    my @Improper_Con_Co = @$improper_co_con_ref;
    my @Bond = @$bond_ref;
    my @Angle = @$angle_ref;
    my @Dihedral = @$dihedral_ref;
    my @Improper = @$improper_ref;
    open(OUT,">/home/philip/HomeDir/misc/LAMMPS_Data_Files/DPPC_test/DPPC_test.prm")  || die "unable to write";
    print OUT "BOND COEFFICIENTS\n";
    print OUT "Bo           Kb\n";
    while( "@Bond_Con_Co" ne '') {
        $Bond1=shift(@Bond);
        $Bond2=shift(@Bond);
        $Bond_Con_Co1=shift(@Bond_Con_Co);
        $Bond_Con_Co2=shift(@Bond_Con_Co);
        print OUT "$Bond1 $Bond2    $Bond_Con_Co1    $Bond_Con_Co2\n";
    }
    print OUT "ANGLE COEFFICIENTS\n";
    print OUT "The0           Kthe\n";
    while( "@Angle_Con_Co" ne '') {
        $Angle1=shift(@Angle);
        $Angle2=shift(@Angle);
        $Angle3=shift(@Angle);
        $Angle_Con_Co1=shift(@Angle_Con_Co);
        $Angle_Con_Co2=shift(@Angle_Con_Co);
        print OUT "$Angle1 $Angle2 $Angle3      $Angle_Con_Co1    $Angle_Con_Co2\n";
    }
    print OUT "DIHEDRAL COEFFICIENTS\n";
    print OUT "The0           Kthe          Mult\n";
    while( "@Dihedral_Con_Co" ne '') {
        $Dihedral1=shift(@Dihedral);
        $Dihedral2=shift(@Dihedral);
        $Dihedral3=shift(@Dihedral);
        $Dihedral4=shift(@Dihedral);
        $Dihedral_Con_Co1=shift(@Dihedral_Con_Co);
        $Dihedral_Con_Co2=shift(@Dihedral_Con_Co);
        $Dihedral_Con_Co3=shift(@Dihedral_Con_Co);
        print OUT "$Dihedral1 $Dihedral2 $Dihedral3 $Dihedral4      $Dihedral_Con_Co1    $Dihedral_Con_Co2   $Dihedral_Con_Co3\n";
    }
    print OUT "IMPROPER COEFFICIENTS\n";
    print OUT "Do           Kd\n";
    while( "@Improper_Con_Co" ne '') {
        $Improper1=shift(@Improper);
        $Improper2=shift(@Improper);
        $Improper3=shift(@Improper);
        $Improper4=shift(@Improper);
        $Improper_Con_Co1=shift(@Improper_Con_Co);
        $Improper_Con_Co2=shift(@Improper_Con_Co);
        print OUT "$Improper1 $Improper2 $Improper3 $Improper4 $Improper_Con_Co1    $Improper_Con_Co2\n";
    }
}