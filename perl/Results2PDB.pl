#!/usr/bin/perl

my %XYZrep;
print "give a minimized file to build from\n";
$MINFILE = <>;
chop $MINFILE;
open(RESULTS,"/home/philip/HomeDir/misc/LAMMPS_Result_Files/$MINFILE") || die "unable to open minimized file\n";
print "give the template pdb file of the original unminimized data file\n";
$PDBFILE = <>;
chop $PDBFILE;
open(PDBFILE,"/home/philip/HomeDir/misc/PDB_Files/$PDBFILE") || die "unable to open PDB file\n";
print "give a pdb file to print out to\n";
$OUT = <>;
chop $OUT;
open(OUT,">/home/philip/HomeDir/misc/PDB_Files/$OUT") || die "unable to open out file\n";
$line=0;
while(<RESULTS>) {
    $line++;
    if (/ITEM: ATOMS/) {
        $last_instance=$line;
    }
}
$line=0;
seek(RESULTS,0,0);
while(<RESULTS>) {
    $line++;
    if ( $line >= $last_instance + 1) {
        @split_line = split(/\s+/,$_);
        $ID = @split_line[0];
        $XCoord = @split_line[3];
        $YCoord = @split_line[4];
        $ZCoord = @split_line[5];
        $XYZrep{$ID}=sprintf("%12.3f%8.3f%8.3f  1.00  0.00",$XCoord,$YCoord,$ZCoord);
        push(@ID_t,$ID);
    }
}
while(<PDBFILE>) {
    $line_number_tot++;
}
seek(PDBFILE,0,0);
while(<PDBFILE>) {
    $current_line++;
    $percent = ($current_line/$line_number_tot) * 100;
    print "$percent\n";
    $i=0;
    $line=substr($_,0,26);
    $a_line=$_;
    map {
        if( $line =~ /^ATOM\s+$_\s+/ ) {
            $out_line = "$line" . "$XYZrep{$_}";
            print OUT "$out_line\n";
            $i=1;
        }
    } @ID_t;
    if($i==0) {
        print OUT "$a_line";
    }
}