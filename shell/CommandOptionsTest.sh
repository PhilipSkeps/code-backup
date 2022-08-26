#!/bin/bash

while getopts ":abc" opt; do
	case $opt in
		a ) echo this one worked;;
		b ) echo so did this one;;
		c ) echo woohoo all three worked;;
		? ) echo 'options include -a, -b, -c or a combination of all three';;
	esac
done
shift $(($OPTIND - 1))	
