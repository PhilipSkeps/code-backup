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
    
    PDB_Arrange.pl $PDB
    modPDB="${basePDB}_mod.pdb"
    
    cat $modPDB | grep -v "TIP" > dppc.pdb
    
    # Generate .top and .itp
    gmx -nobackup pdb2gmx -f dppc.pdb -o temp.gro -i $ITP -p $TOP -ff charmm36_ljpme-jul2021 -water tip3p
    rm temp.gro # remove force made .gro
    
    WAT=$(cat $modPDB | grep -c "TIP")
    WAT=$(($WAT/3))
    
    # Generate .gro with correct dimensions and alter
    gmx -nobackup editconf -f $modPDB -o $GRO -bt triclinic -box $X $Y $Z
    sed -i "s/TIP3/SOL /g" $GRO
    sed -i "s/SOL    OH2/SOL     OW/g" $GRO
    sed -i "s/SOL     H1/SOL    HW1/g" $GRO
    sed -i "s/SOL     H2/SOL    HW2/g" $GRO
    printf "SOL%18s\n" "$WAT" >> $TOP

    if [[ $6 =~ ".pdb" ]]; then # make graphene modifications
        sed -i "s/GRPH/GP00/g" $6
        GromGrapheneGro.pl $GRO $6 "$baseMDP.gro"
        GRO="$baseMDP.gro"
        GromGrapheneItp.pl $6
        GromGrapheneTop.pl $TOP "${TOP%%.*}g.top"
        TOP="${TOP%%.*}g.top"
    fi
    
else # otherwise we know what the gro file is becuase user input
    
    GRO=$2 
    TOP=$3

    if [[ $4 =~ ".pdb" ]]; then # make graphene modifications
        GromGrapheneGro.pl $GRO $4 "$baseMDP.gro"
        GRO="$baseMDP.gro"
        GromGrapheneItp.pl $4
        GromGrapheneTop.pl $TOP "${TOP%%.*}g.top"
        TOP="${TOP%%.*}g.top"
    fi

fi # end if

# create the index files for grouping
gmx -nobackup make_ndx -f $GRO -o $NDX << EOF
q
EOF
    
# Create TPR
gmx -nobackup grompp -f $MDP -c $GRO -p $TOP -o $TPR -n $NDX -po $FUL
