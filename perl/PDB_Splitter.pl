#!/usr/bin/perl

&main;

sub main {

    my $pdbTitle = @ARGV[0];
    #my $pdbTitle = "/home/pskeps/HomeDir/misc/CHARMM_Input_Files/waterDPPC/water_dppc.pdb";

    if ( $pdbTitle =~ /^.*\.pdb$/ ) {
        &loopFile($pdbTitle);
    }

}

sub loopFile {

    my $newSegId;
    my $oldSegId;
    my $modifier; 
    my $repNumber;
    my $i = 0;
    my $spaces;
    my $pdbTitle = shift;
    open(IN,"$pdbTitle") || die "unable to open $pdbTitle";

    while(<IN>) {

        $newSegId = substr($_,72,3);
        if (/^ATOM|^HETATOM/) {$i++;}
        if ( $newSegId ne $oldSegId || $i == 1 || /^END/ ) {
            if ( /^[^0-9]*([0-9]*)\s+/ ) { $modifier = $1 - 1; }
            if( fileno(OUT) ) {
                print OUT "END";
                close(OUT);
            }
            if ( $_ !~ /^END/ ) {
                my $segId = lc($newSegId);    
                my $newFile = &fileName($pdbTitle,$segId);
                open(OUT,">$newFile") || die "Unable to open $newFile";
            }    
        }
        $oldSegId = substr($_,72,3);

        if( fileno(OUT) ) {
            if ( /^[^0-9]*([0-9]*)\s+/ ) { $repNumber = $1 - $modifier; }
            if ( /^[^\s+]*(\s+)[^\s+]/ && $i == 1 ) { $spaces = $1; }
            my $newSpaces = &corSpacing($repNumber,$spaces);
            $repNumber = $newSpaces . $repNumber;
            s/\s+[0-9]*/$repNumber/;
            print OUT $_;    
        }
        
    }

    close(IN);

}

sub fileName {

    my $file = shift;
    my $fileAdd = shift;
    $file =~ s/(\..*)//g;
    my $fileExtension = $1;
    my $newFile = $file . $fileAdd . $fileExtension;
    
    return $newFile; 
}

sub corSpacing {

    use integer;

    my $number = shift;
    my $spaces = shift;
    my $digits = 0;

    while( $number != 0 ) {
        $number = $number/10;
        $digits++;
    }

    $spaces = substr($spaces,0,length($spaces) - $digits + 1);

    return $spaces;

}
