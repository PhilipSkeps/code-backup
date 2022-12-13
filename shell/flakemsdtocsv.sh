#!/bin/bash

# assumes xvg file format

CSV="${1%%.*}.csv"

cp $1 $CSV

sed -i "/^@.*$/d" $CSV # remove comments
sed -i "/^#.*$/d" $CSV #remove comments
sed -Ei "s/^\s+//g" $CSV # trim whitespace at beginning
sed -Ei "s/\s+$//g" $CSV # trim whitespace at the end
sed -Ei "s/\s+/,/g" $CSV # convert seperating whitespace into commas

echo $CSV written

matlab -nosplash -nodesktop -r "FILE='$PWD/$CSV';run('/home/pskeps/HomeDir/dev/matlab/logMSD/logMSD.m');exit"