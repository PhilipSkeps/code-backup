#!/usr/bin/perl

&main();

sub main() {

    my $IN = @ARGV[0];
    open(FIN,'<',$IN) || die "unable to open $IN";
    my $OUT = $IN;
    $OUT =~ s/.pdb/_mod.pdb/g;
    open(OUT,'>',$OUT) || die "unable to open $OUT";

    while(<FIN>) {
        if (/TIP/) { push(@Store_Line,$_) }
        else { print OUT $_ }
    }
    map { print OUT $_ } @Store_Line;

}
