#!/bin/bash

Cleaner()
{
package=$(dir)
for file in $package; do 
	fileext=${file##*.}
	if [ $fileext == "tgz" ] || [ $fileext == "tar" ] || [ $fileext == "gz" ]; then
		mkdir "Unpacked-${file%%.*}"
		tar -C "Unpacked-${file%%.*}" -xf $file
		rm $file
		if [[ -d ${file%%.*} ]]; then
			rm -r ${file%%.*}
		fi
			cd "Unpacked-${file%%.*}"
			Cleaner
			cd ..		
	else
		if [ -d $file ]; then
			cd $file
			Cleaner
			cd ..
		fi
	fi
done 
}

ogfile=${1##*.}
if [ $ogfile == "tgz" ] || [ $ogfile == "tar" ] || [ $ogfile == "gz" ]; then
	mkdir "Unpacked-${1%%.*}"
	tar -C "Unpacked-${1%%.*}" -xf $1
	cd "Unpacked-${1%%.*}"
	Cleaner	
fi




		
