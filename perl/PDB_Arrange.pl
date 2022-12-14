#!/usr/bin/perl

# Hey Eileen, this script exists to take all of the lines of the PDB file, we will discuss what this is later, and rearrange it so that
# lines that represent an atom of the water in the simulation appear last
# this is done to make my life easier while processing it with gromacs

# a call to the function main (this is just a practice I like to follow but is not necessary)
&main();

sub main() {

    # take the file name from the command line
    my $IN = @ARGV[0];
    open(FIN,'<',$IN) || die "unable to open $IN"; # open file or if failed exit the program
    my $OUT = $IN;
    # change the filename from [filename].pdb to [filename]_mod.pdb
    $OUT =~ s/.pdb/_mod.pdb/g;
    open(OUT,'>',$OUT) || die "unable to open $OUT"; # open out file for writing or if failed exit the program

    # loop through all lines of the file
    while(<FIN>) {
        if (/TIP/) { push(@Store_Line,$_) } # if the line contains the string "TIP" then simply store the line in an array
        else { print OUT $_ } # otherwise print the line to the outfile
    }
    map { print OUT $_ } @Store_Line; # now print all of the stored lines

}
