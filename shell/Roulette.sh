#!/bin/bash
number=0
win="False"
IFS=:
rplays=('Straight Up:Row:Split:Street:Corner:Basket:Six Line:Column:Dozen:Odd:Even:Red:Black:1-18:19-36':Done)
finalwin="False"
redwinningnumbers=('1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36')
blackwinningnumbers=('2,4,6,8,10,11,13,15,17,20,22,24,26,28,29,31,33,35')
i=0
let t=1
let f=1
let g=1
let h=1
let z=0
let l=0
let j=0
let r=1
let w=1
let q=1
let a=1
let d=1
let k=1
let o=1
let cornershift=0
let streetshift=0
let codownshift=0
let coshift=0
comma="False"
rowbet="False"
basketbet="False"
sicommaseperator=''
dcommaseperator=''
stcolonseperator=''
ccolonseperator=''
scolonseperator=''
sicolonseperator=''
dcolonseperator=''
declare -a chosenbets
declare -a chosencash
declare -a splitchoices
declare -a betsplit
declare -a streetchoices
declare -a cornerchoices
declare -a sixlinechoices

while [ "$number" -ge 37 ]; do
	number=$RANDOM
	if [ "$number" == 37 ]; then
		number=00
	fi
done

straightupchoicesgenerator()
{
while [ $t -le 36 ]; do
	straightupchoices+="$stcolonseperator$t"
	t=$(($t+1))
	stcolonseperator=':'
done
straightupchoices+=":0:00:Done"
}	

splitchoicesgenerator()
{
while [ $f -le "33" ]; do
	if [ $f -eq "1" ]; then
		splitchoices+="$f"
		splitchoices+=",$(($f+1))"
		splitchoices+=":$f"
		splitchoices+=",$(($f+3))"
	fi
	if [ $((f%5)) -eq 0 ]; then
		splitchoices+=":$f"
		splitchoices+=",$(($f+3))"
	else 
		splitchoices+=":$f"
		splitchoices+=",$(($f+1))"
		splitchoices+=":$f"
		splitchoices+=",$(($f+3))"
	fi
	f=$(($f+1))
done
splitchoices+=":Done"
}

streetchoicesgenerator()
{
while [ $g -le "12" ]; do
	streetshift=$(($((g-1))*3))
	streetchoices+="$scolonseperator$((1+$streetshift)),$((2+$streetshift)),$((3+$streetshift))"
	scolonseperator=':'
	g=$(($g+1))
done
streetchoices+=":Done"
}

cornerchoicesgenerator()
{
while [ $h -le "22" ]; do
	cornerchoices+="$ccolonseperator$(($h+$cornershift)),$(($h+1+$cornershift)),$(($h+3+$cornershift)),$(($h+4+$cornershift))"
	ccolonseperator=':'
	if [ $((h%4)) -eq 0 ]; then
		cornershift=$(($((h/4))*2))
	fi
	h=$(($h+1))
done
cornerchoices+=":Done"
}

sixlinechoicesgenerator()
{
while [ $z -le "65" ]; do
	sixlinechoices+="$sicolonseperator$sicommaseperator$(($z-3*$(($z/6))+1))"
	z=$(($z+1))
	if [ $(($z%65)) -ne 0 ]; then
		sicommaseperator=','
	fi
	if [ $(($z%6)) -eq 0 ]; then
		sicolonseperator=':'
		sicommaseperator=''
	else
		sicolonseperator=''
	fi
done
sixlinechoices+=":Done"
}

columnchoicesgenerator()
{
while [ $l -le 35 ]; do
	columnchoices+="$cocolonseperator$cocommaseperator$((3*l+1+$coshift+$codownshift))"
	l=$(($l+1))
	if [ $(($l%36)) -ne 0 ]; then
		cocommaseperator=','
	fi
	if [ $(($l%12)) -eq 0 ]; then
		cocolonseperator=':'
		cocommaseperator=''
		codownshift=$(($codownshift-36))
		coshift=$(($coshift+1))
	else
		cocolonseperator=''
	fi
done
columnchoices+=":Done"
}

dozenchoicesgenerator()
{
while [ $j -le 35 ]; do
	dozenchoices+="$dcolonseperator$dcommaseperator$((j+1))"
	j=$(($j+1))
	if [ $(($j%36)) -ne 0 ]; then
		dcommaseperator=','
	fi
	if [ $(($j%12)) -eq 0 ]; then
		dcolonseperator=':'
		dcommaseperator=''
	else
		dcolonseperator=''
	fi
done
dozenchoices+=":Done"
}

straightup()
{
IFS=':'
echo -e '################################################################################'
echo 'Select a Number Given Including 0 and 00 Below then Type in your Bet Value.' 
echo 'Returns 35 to 1. When You Would Like to Return to Bet Select, Select Done'
echo "Your Total Funds is $totalfunds"
echo -e '################################################################################'
select straightupbets in ${straightupchoices[@]}; do
	if [ $straightupbets != "Done" ]; then
		echo 'Type a Bet Value'
		read Tempstraightupbetvalue
		for r in ${!betstraightup[@]}; do
			if [[ ${betstraightup[$r]} == $straightupbets ]]; then
				unset straightupbetvalue[$r]
				unset betstraightup[$r]
			fi	
		done
		betstraightup+=($straightupbets)
		straightupbetvalue+=($Tempstraightupbetvalue)
		straightup
		break
	else
		echo 'Your Bet has Been Placed! :)'
		betselect
		break
	fi
done	
}

row()
{
IFS=' '
echo -e '################################################################################'
echo 'This Bet Includes the numbers "0,00" and returns 17 to 1. Type in Your Bet Value'
echo 'Followed by Done. i.e "120 Done". To Return to Bet Select just Type Done'
echo "Your Total Funds is $totalfunds"
echo -e '################################################################################'
rowbet="True"
read -a betrow
end=$(( ${#betrow[@]} - 1))
if [ ${betrow[$end]} == Done ]; then
	echo 'Your Bet(s) has Been Placed :)'
	betselect
else 
	echo 'End Your bet Statement with "Done" to Return to the Select Bet Screen'
	row
fi
if [ ${betrow[0]} -eq ${betrow[0]} ]; then
	arowbet=${betrow[0]}
fi 2>/dev/null
}

split()
{
echo -e '################################################################################'
echo 'Select a Pair of Numbers Given Below then Type in your Bet Value. Returns' 
echo '17 to 1. When You Would Like to Return to Bet Select, Select Done'
echo "Your Total Funds is $totalfunds"
echo -e '################################################################################'
select splitbets in ${splitchoices[@]}; do
	if [ $splitbets != "Done" ]; then
		echo 'Type a bet Value'
		read Tempsplitbetvalue
		for w in ${!betsplit[@]}; do
			if [[ ${betsplit[$w]} == $splitbets ]]; then
				totalfunds=$(($totalfunds+${splitbetvalue[$r]}))
				unset splitbetvalue[$w]
				unset betsplit[$w]
			fi	
		done
		betsplit+=($splitbets)
		splitbetvalue+=($Tempsplitbetvalue)
		for i in ${!splitbetvalue[@]}; do
			totalfunds=$(($totalfunds-${splitbetvalue[$i]}))
		done
		split
		break
	else
		echo 'Your Bet has Been Placed! :)'
		betselect
		break
	fi
done
}

street()
{
echo -e '################################################################################'
echo 'Select a Triplet of Numbers Given Below then Type in your Bet Value. Returns' 
echo '11 to 1. When You Would Like to Return to Bet Select, Select Done'
echo "Your Total Funds is $totalfunds"
echo -e '################################################################################'
select streetbets in ${streetchoices[@]}; do
	if [ $streetbets != "Done" ]; then
		echo 'Type a Bet Value'
		read Tempstreetbetvalue
		for q in ${!betstreet[@]}; do
			if [[ ${betstreet[$q]} == $streetbets ]]; then
				unset streetbetvalue[$q]
				unset betstreet[$q]
			fi	
		done
		betstreet+=($streetbets)
		streetbetvalue+=($Tempstreetbetvalue)
		street
		break
	else
		echo 'Your Bet has Been Placed! :)'
		betselect
		break
	fi
done	
}

corner()
{
echo -e '################################################################################'
echo 'Select a Quartet of Numbers Given Below then Type in your Bet Value. Returns' 
echo '8 to 1. When You Would Like to Return to Bet Select, Select Done'
echo "Your Total Funds is $totalfunds"
echo -e '################################################################################'
select cornerbets in ${cornerchoices[@]}; do
	if [ $cornerbets != "Done" ]; then
		echo 'Type a Bet Value'
		read Tempcornerbetvalue
		for a in ${!betcorner[@]}; do
			if [[ ${betcorner[$a]} == $cornerbets ]]; then
				unset cornerbetvalue[$a]
				unset betcorner[$a]
			fi	
		done
		betcorner+=($cornerbets)
		cornerbetvalue+=($Tempcornerbetvalue)
		corner
		break
	else
		echo 'Your Bet has Been Placed! :)'
		betselect
		break
	fi
done	
}

basket()
{
IFS=' '
echo -e '################################################################################'
echo 'This Bet Includes the numbers "0,00,1,2,3" and returns 6 to 1. Type in Your Bet' 
echo 'Value Followed by Done. i.e "120 Done". To Return to Bet Select just Type Done'
echo "Your Total Funds is $totalfunds"
echo -e '################################################################################'
basketbet="True"
read -a betbasket
end=$((${#betbasket[@]} - 1))
if [ ${betbasket[$end]} == Done ]; then
	echo 'Your Bet(s) has Been Placed :)'
	betselect
else 
	echo 'End Your bet Statement with "Done" to Return to the Select Bet Screen'
	basket
fi
if [ ${betbasket[0]} -eq ${betbasket[0]} ]; then
	abasketbet=${betbasket[0]}
fi 2>/dev/null
}

sixline()
{
echo -e '################################################################################'
echo 'Select a Sixtet of Numbers Given Below then Type in your Bet Value. Returns' 
echo '8 to 1. When You Would Like to Return to Bet Select, Select Done'
echo "Your Total Funds is $totalfunds"
echo -e '################################################################################'
select sixlinebets in ${sixlinechoices[@]}; do
	if [ $sixlinebets != "Done" ]; then
		echo 'Type a Bet Value'
		read Tempsixlinebetvalue
		for k in ${!betsixline[@]}; do
			if [[ ${betsixline[$k]} == $sixlinebets ]]; then
				unset sixlinebetvalue[$k]
				unset betsixline[$k]
			fi	
		done
		betsixline+=($sixlinebets)
		sixlinebetvalue+=($Tempsixlinebetvalue)
		sixline
		break
	else
		echo 'Your Bet has Been Placed! :)'
		betselect
		break
	fi
done	
}

column()
{
echo -e '################################################################################'
echo 'Select a Column of Numbers Given Below then Type in your Bet Value. Returns' 
echo '5 to 1. When You Would Like to Return to Bet Select, Select Done'
echo "Your Total Funds is $totalfunds"
echo -e '################################################################################'
select columnbets in ${columnchoices[@]}; do
	if [ $columnbets != "Done" ]; then
		echo 'Type a Bet Value'
		read Tempcolumnbetvalue
		for d in ${!betcolumn[@]}; do
			if [[ ${betcolumn[$d]} == $columnbets ]]; then
				unset columnbetvalue[$d]
				unset betcolumn[$d]
			fi	
		done
		betcolumn+=($columnbets)
		columnbetvalue+=($Tempcolumnbetvalue)
		column
		break
	else
		echo 'Your Bet has Been Placed! :)'
		betselect
		break
	fi
done	
}

dozen()
{
echo -e '################################################################################'
echo 'Select a Dozen of Numbers Given Below then Type in your Bet Value. Returns' 
echo '2 to 1. When You Would Like to Return to Bet Select, Select Done'
echo "Your Total Funds is $totalfunds"
echo -e '################################################################################'
select dozenbets in ${dozenchoices[@]}; do
	if [ $dozenbets != "Done" ]; then
		echo 'Type a Bet Value'
		read Tempdozenbetvalue
		for o in ${!betdozen[@]}; do
			if [[ ${betdozen[$o]} == $dozenbets ]]; then
				unset dozenbetvalue[$o]
				unset betdozen[$o]
			fi	
		done
		betdozen+=($dozenbets)
		dozenbetvalue+=($Tempdozenbetvalue)
		dozen
		break
	else
		echo 'Your Bet has Been Placed! :)'
		betselect
		break
	fi
done	
}

odd()
{
IFS=' '
echo -e '################################################################################'
echo 'This Bet Includes All Odd Numbers (1-36) and returns 1 to 1. Type in Your Bet' 
echo 'Value Followed by Done. i.e "120 Done". To Return to Bet Select just Type Done'
echo "Your Total Funds is $totalfunds"
echo -e '################################################################################'
oddbet="True"
read -a betodd
end=$((${#betodd[@]} - 1))
if [ ${betodd[$end]} == Done ]; then
	echo 'Your Bet(s) has Been Placed :)'
	betselect
else 
	echo 'End Your bet Statement with "Done" to Return to the Select Bet Screen'
	odd
fi
if [ ${betodd[0]} -eq ${betodd[0]} ]; then
	aoddbet=${betodd[0]}
fi 2>/dev/null
}

even()
{
IFS=' '
echo -e '################################################################################'
echo 'This Bet Includes All Even Numbers (1-36) and returns 1 to 1. Type in Your Bet' 
echo 'Value Followed by Done. i.e "120 Done". To Return to Bet Select just Type Done'
echo "Your Total Funds is $totalfunds"
echo -e '################################################################################'
evenbet="True"
read -a beteven
end=$((${#beteven[@]} - 1))
if [ ${beteven[$end]} == Done ]; then
	echo 'Your Bet(s) has Been Placed :)'
	betselect
else 
	echo 'End Your bet Statement with "Done" to Return to the Select Bet Screen'
	even
fi
if [ ${beteven[0]} -eq ${beteven[0]} ]; then
	aevenbet=${beteven[0]}
fi 2>/dev/null
}

red()
{
IFS=' '
echo -e '################################################################################'
echo 'This Bet Includes the numbers "1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36"' 
echo 'and returns 1 to 1. Type in Your Bet Value Followed by Done. i.e "120 Done".'
echo 'To Return to Bet Select just Type Done'
echo "Your Total Funds is $totalfunds"
echo -e '################################################################################'
redbet="True"
read -a betred
end=$((${#betred[@]} - 1))
if [ ${betred[$end]} == Done ]; then
	echo 'Your Bet(s) has Been Placed :)'
	betselect
else 
	echo 'End Your bet Statement with "Done" to Return to the Select Bet Screen'
	red
fi
if [ ${betred[0]} -eq ${betred[0]} ]; then
	aredbet=${betred[0]}
fi 2>/dev/null
}

black()
{
IFS=' '
echo -e '################################################################################'
echo 'This Bet Includes the numbers "2,4,6,8,10,11,13,15,17,20,22,24,26,28,29,31,33,35"' 
echo 'and returns 1 to 1. Type in Your Bet Value Followed by Done. i.e "120 Done".'
echo 'To Return to Bet Select just Type Done'
echo "Your Total Funds is $totalfunds"
echo -e '################################################################################'
blackbet="True"
read -a betblack
end=$((${#betblack[@]} - 1))
if [ ${betblack[$end]} == Done ]; then
	echo 'Your Bet(s) has Been Placed :)'
	betselect
else 
	echo 'End Your bet Statement with "Done" to Return to the Select Bet Screen'
	black
fi
if [ ${betblack[0]} -eq ${betblack[0]} ]; then
	ablackbet=${betblack[0]}
fi 2>/dev/null
}

first()
{
IFS=' '
echo -e '################################################################################'
echo 'This Bet Includes the numbers "1 to 18" and returns 1 to 1. Type in Your Bet' 
echo 'Value Followed by Done. i.e "120 Done". To Return to Bet Select just Type Done'
echo "Your Total Funds is $totalfunds"
echo -e '################################################################################'
firstbet="True"
read -a betfirst
end=$((${#betfirst[@]} - 1))
if [ ${betfirst[$end]} == Done ]; then
	echo 'Your Bet(s) has Been Placed :)'
	betselect
else 
	echo 'End Your bet Statement with "Done" to Return to the Select Bet Screen'
	first
fi
if [ ${betfirst[0]} -eq ${betfirst[0]} ]; then
	afirstbet=${betfirst[0]}
fi 2>/dev/null
}

second()
{
IFS=' '
echo -e '################################################################################'
echo 'This Bet Includes the numbers "19-36" and returns 6 to 1. Type in Your Bet' 
echo 'Value Followed by Done. i.e "120 Done". To Return to Bet Select just Type Done'
echo "Your Total Funds is $totalfunds"
echo -e '################################################################################'
secondbet="True"
read -a betsecond
end=$((${#betsecond[@]} - 1))
if [ ${betsecond[$end]} == Done ]; then
	echo 'Your Bet(s) has Been Placed :)'
	betselect
else 
	echo 'End Your bet Statement with "Done" to Return to the Select Bet Screen'
	second
fi
if [ ${betsecond[0]} -eq ${betsecond[0]} ]; then
	asecondbet=${betsecond[0]}
fi 2>/dev/null
}

betselect()
{
IFS=:
echo -e '################################################################################' 
echo 'Choose From the List of Bets! When You Have Placed All of Your Bets Select Done!'
echo 'To See What Numbers and the Return of Each Bet is Select the Bet'
echo "Your Total Funds is $totalfunds"
echo -e '################################################################################'
select bet in $rplays; do 
	case $bet in
		"Straight Up" ) straightup;;
		"Row"         ) row;;
		"Split"       ) split;;
		"Street"      ) street;;
		"Corner"      ) corner;;
		"Basket"      ) basket;;
		"Six Line"    ) sixline;;
		"Column"      ) column;;
		"Dozen"       ) dozen;;
		"Odd"         ) odd;;
		"Even"        ) even;;
		"Red"         ) red;;
		"Black"       ) black;;
		"1-18"        ) first;;
		"19-36"       ) second;;
		"Done"        ) echo "The Table is Spinning!"
				sleep 5
				finalwin="True";;
	esac
	break
done
}

straightupcalc()
{
}

splitcalc()
{
}
let number="00"
let totalfunds=150
straightupchoicesgenerator
dozenchoicesgenerator
columnchoicesgenerator
sixlinechoicesgenerator
cornerchoicesgenerator
streetchoicesgenerator
splitchoicesgenerator
betselect
straightupcalc
splitcalc
echo ${betstraightup[@]}
echo ${straightupbetvalue[@]}
echo ${betsplit[@]}
echo ${splitbetvalue[@]}
echo ${betstreet[@]}
echo ${streetbetvalue[@]}
echo ${betcorner[@]}
echo ${cornerbetvalue[@]}
echo ${betsixline[@]}
echo ${sixlinebetvalue[@]}
echo ${betcolumn[@]}
echo ${columnbetvalue[@]}
echo ${betdozen[@]}
echo ${dozenbetvalue[@]}
echo $aevenbet
echo $aoddbet
echo $aredbet
echo $ablackbet
echo $afirstbet
echo $asecondbet
echo $totalfunds
