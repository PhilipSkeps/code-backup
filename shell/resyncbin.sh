#!/bin/bash

cd ~/HomeDir/bin
for file in *; do
   if [[ -L $file ]]; then
	unlink $file
   fi
done

cd ~/HomeDir/dev
Recurse() {
    for file in *; do
        if [[ -d $file && ! $file =~ NoSync$ ]]; then
            cd $file
 	    Recurse
	    cd ..
        elif [[ -x $file ]]; then
	    ln -s $PWD/$file ~/HomeDir/bin
	else
	    continue
        fi
    done
}

Recurse
