#!/usr/bin

EDR="$1"
TPR="$2"
XVG="${EDR%%.*}.xvg"

gmx energy -f ${EDR} -s ${TPR} -o ${XVG} << EOF
Pressure
T-rest
Potential
0
EOF

cat ${XVG} | gromGrapher.pl