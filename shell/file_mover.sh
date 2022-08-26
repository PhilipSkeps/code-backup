#!/bin/bash

move_file() {
   echo -e "\nIn Directory $PWD"
   files=$(dir)
   echo -e "Moving Files"
   for file in $files; do
       if [[ $file =~ ^[0-9]{7}$ ]] && [[ ! $(check_job | grep "$file") ]]; then
           mv "$file" ~/scratch/Storage;
           echo "$file "
       elif check_job | grep "$file"; then
           echo -e "\nUnable to move $file. Currently in Job\n"
       fi
   done

   echo -e "Completed Move of valid directories"
   directories=$files

   cd ~ || (echo "Failed to change directories line 20"  && exit)
   files=$(dir)
   for directory in $directories; do
       for file in $files; do
           if [[ $file =~ $directory ]]; then
               mv "$file" ~/scratch/Storage/"$directory"
           fi
       done
   done
}

if [[ "$1" == "C" ]]; then
   cd ~/scratch/CHARMM_Results_Files
   move_file
elif [[ "$1" == "L" ]]; then
   cd ~/scratch/LAMMPS_Results_Files
   move_file
else
   echo "Please provide either -L or -R option"
fi

