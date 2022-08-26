#!/usr/bin/perl

$count=a;
$check=1;
print "give a graphene file to doctor\n";
$FILE=<>;
$WRITEFILE=$FILE;
$WRITEFILE=~s/\.pdb/_inp\.pdb/;
my $first_piece;
chdir('/home/pskeps/HomeDir/misc/PDB_Files') || die "unable to open /home/pskeps/HomeDir/misc/PDB_Files";
open(FILE,$FILE) || die "unable to open $FILE";
open(WRITEFILE,">$WRITEFILE");
while(<FILE>) {
    if (/^HETATM/ || /^ATOM/ || /^TER/ || /^HELIX/ || /^SHEET/ || /^SSBOND/) {
        $first_piece=substr($_,0,17);
        if ( /\s+[0-9]*C[a-z]*\s+/ ) {
            ($first_piece)=make_atom_code('C',$first_piece);
        }
        if ( /\s+[0-9]*H[0-9]*\s+/ ) {
            ($first_piece)=make_atom_code('H',$first_piece);
        }
        $check=substr($_,17,4);
        $second_piece=substr($_,21);
        $first_piece= $first_piece . "GRPH";
        #if ($check eq "    ") {
            #print WRITEFILE "$first_piece$second_piece";
        #}
        #else {
            #$_=~s/UNK /GRPH/;
            #print WRITEFILE $_;
        #}
        print WRITEFILE "$first_piece$second_piece";
    }
    elsif ( $_ !~ /^CONECT/ ) {
        print WRITEFILE $_;
    }
    if (/^END/) {
        $check=0;
    }
}

if ($check == 1)  {
    print WRITEFILE 'END';
}


sub make_atom_code {
    my $current_code=shift;
    my $first_piece=shift;
    my $string= $current_code . $count;
    if ( /\s+[0-9]*$current_code[0-9]*[a-z]*\s+/ ) {
        $lenght_count=length($count);
        if ($lenght_count == 1) {
            $first_piece =~ s/\s+[0-9]*$current_code[0-9]*[a-z]*\s+/ $string   /;
        }
        elsif ( $lenght_count == 2) {
            $first_piece =~ s/\s+[0-9]*$current_code[0-9]*[a-z]*\s+/ $string  /;
        }
        else {
            $first_piece =~ s/\s+[0-9]*$current_code[0-9]*[a-z]*\s+/ $string /;
        }
    }
    $count++;
    return($first_piece);
}