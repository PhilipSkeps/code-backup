#!/usr/bin/perl

$true=1;
print 'Provide File 1:   ';
$FILE1=<>;
chop($FILE1);
print 'Provide File 2:   ';
$FILE2=<>;
chop($FILE2);
open(FILE1,$FILE1) || die "unable to open $FILE1";
open(FILE2,$FILE2) || die "unable to open $FILE2";
while(<FILE1>) {
    push(@FILE1,$_);
}
while(<FILE2>) {
    push(@FILE2,$_);
}
$length_FILE1=@FILE1;
$length_FILE2=@FILE2;
if ($length_FILE1 <= $length_FILE2) {
    $length=$length_FILE2;
}
else {
    $length=$length_FILE1;
}
for ($i=0 ; $i<$length ; $i++) {
    if ($i > $length_FILE1) {
        push(@EXTRA2,@FILE2[$i]);
        $true=0;
    }
    if ($i > $length_FILE2 ) {
        push(@EXTRA1,@FILE1[$i]);
        $true=0;
    }
    if (@FILE1[$i] != @FILE2[$i] && $true == 1) {
        push(@FAIL1,@FILE1[$i]);
        push(@FAIL2,@FILE2[$i]);
        push(@LINENUMBER,$i);
    }
}
while ("@FAIL1" ne '') {
    $FAIL1=shift(@FAIL1);
    $FAIL2=shift(@FAIL2);
    $LINENUMBER=shift(@LINENUMBER);
    print "$FILE1 line $LINENUMBER: $FAIL1";
    print "$FILE2 line $LINENUMBER: $FAIL2";
}
print "EXTRA $FILE1\n";
while ("@EXTRA1" ne '') {
    $EXTRA1=shift(@EXTRA1);
    print "$EXTRA1";
}
print "EXTRA $FILE2\n";
while ("@EXTRA2" ne '') {
    $EXTRA2=shift(@EXTRA2);
    print "$EXTRA2";
}