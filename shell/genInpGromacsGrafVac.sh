#!/bin/bash
    
# clear environment:
module purge 
# MPI:
module load compilers/gcc/9.3.1
module load mpi/openmpi/gcc/3.1.3
module load libs/fftw/gcc9-ompi/3.3.8
module load apps/gromacs/gcc-ompi/2021.1
    
# FILES
MDP=$1
baseMDP=${MDP%%.*}
ITP="${baseMDP}.itp"
TPR="${baseMDP}.tpr"
NDX="${baseMDP}.ndx"
FUL="${baseMDP}full.mdp"
    
# if it is a pdb input go through extensive process to create .gro file
if [[ $2 =~ ".pdb" ]]; then
    
    # PDB FILE
    PDB=$2
    basePDB="${PDB%%.*}"
    GRO="${baseMDP}.gro"
    TOP="${basePDB}.top"
    
    # BOX DIMENSIONS
    X=$3
    Y=$4
    Z=$5
    
cat << EOF > $TOP
; Include forcefield parameters
#include "./charmm36_ljpme-jul2021.ff/forcefield.itp"
#include "./NMA.itp"

[ system ]
; Name
Graphene

[ molecules ]
; Compound      #mols
NMA                1
EOF
    
    GromGrapheneItp.pl $PDB

    # Generate .gro with correct dimensions and alter
    gmx -nobackup editconf -f $PDB -o $GRO -bt triclinic -box $X $Y $Z
    
else # otherwise we know what the gro file is becuase user input
    
    GRO=$2 
    TOP=$3

fi # end if

# create the index files for grouping
gmx -nobackup make_ndx -f $GRO -o $NDX << EOF
splitres
q
EOF

# Create TPR; maxwarn is required due to a bug in gromacs that forces gpu support on pme cut-off
gmx -nobackup grompp -f $MDP -c $GRO -p $TOP -o $TPR -n $NDX -po $FUL -maxwarn 1

