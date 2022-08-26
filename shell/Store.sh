#!/bin/bash

#array=($(sshpass -p '1Gucciflipflop=' ssh pskeps@wendian002.mines.edu "ls ~/LAMMPS_Results_Files/Research")) 
array=($(sshpass -p '1Gucciflipflop=' ssh pskeps@wendian002.mines.edu "ls ~/scratch/Storage"))
for file in "${array[@]}"; do
    if [[ $file =~ [0-9]* ]]; then
        #sshpass -p '1Gucciflipflop=' scp -r pskeps@wendian002.mines.edu:/u/sa/br/pskeps/LAMMPS_Results_Files/Research/"$file" ~/Old_Jobs
        sshpass -p '1Gucciflipflop=' scp -r pskeps@wendian002.mines.edu:/u/sa/br/pskeps/scratch/Storage/"$file" ~/Old_Jobs
    fi
done
