#!/bin/bash

# clear environment:
module purge 
# MPI:
module load compilers/devtoolset/9
module load mpi/openmpi/3.1.3-gnu-7.3.1
module load libs/fftw/3.3.8-gcc9-ompi
module load apps/gromacs/2021.1-gnu-openmpi

# FILES
PDB=$1
MDP=$2
basePDB=${PDB%%.*}
ITP="${basePDB}.itp"
TOP="${basePDB}.top"
GRO="${basePDB}.gro"
TPR="${basePDB}.tpr"

# BOX DIMENSIONS
X=$3
Y=$4
Z=$5

PDB_Arrange $PDB
modPDB="${basePDB}_mod.pdb"

cat $1 | grep -v "TIP" > dppc.pdb

# Generate .top and .itp
gmx pdb2gmx -f dppc.pdb -o temp.gro -i $ITP -p $TOP -ff charmm36_ljpme-jul2021 -water tip3p
rm temp.gro # remove force made .gro

WAT=$(cat $1 | grep -c "TIP")
WAT=$(($WAT/3))

# Generate .gro with correct dimensions and alter
gmx editconf -f $modPDB -o $GRO -bt triclinic -box $X $Y $Z
sed -i "s/TIP3/SOL /g" $GRO
sed -i "s/SOL    OH2/SOL     OW/g" $GRO
sed -i "s/SOL     H1/SOL    HW1/g" $GRO
sed -i "s/SOL     H2/SOL    HW2/g" $GRO
echo "SOL              $WAT" >> $TOP

# Create TPR
gmx grompp -f $MDP -c $GRO -p $TOP -o $TPR -po full.mdp
