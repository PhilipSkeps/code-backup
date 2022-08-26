#!/bin/bash

for file in $( ls | grep 'psf' ); do
    if [[ $file =~ .*_formatted.pdb ]]; then
        dir=${file%_formatted.pdb}
    else
        dir=${file%.*}
    fi
    mkdir -p ~/HomeDir/misc/PSF_File/CHARMM_Files/$dir
    mv $file ~/HomeDir/misc/PSF_File/CHARMM_Files/$dir
done 
echo -e "Finished"