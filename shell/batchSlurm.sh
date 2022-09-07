#!/bin/bash

##############################################################################################################################################
## OPTION HANDLING
##############################################################################################################################################

FORCEF=/u/sa/br/pskeps/GROM_SIM/charmm36_ljpme-jul2021.ff

unset NUM
unset MINMDP
unset HEATMDP
unset EQUMDP
unset PRODMDP
unset COORDFILE
unset DIMENSIONS

USAGE="$(basename "$0") [-h] [-m MINMDP] [-t HEATMDP] [-e EQUMDP] [-p PRODMDP] [-c COORDFILE] [-d DIMENSIONS] [-n NUMRUNTIMES]"

while getopts ":hn:m:t:e:p:c:d:" flag; do
    case "${flag}" in
        n) NUM=${OPTARG};;
        m) MINMDP=${OPTARG};;
        t) HEATMDP=${OPTARG};;
        e) EQUMDP=${OPTARG};;
        p) PRODMDP=${OPTARG};;
        c) COORDFILE=${OPTARG};;
        d) IFS=',' eval 'DIMENSIONS=($OPTARG)';; # must be comma delimited
        h) echo "$USAGE"; exit 1;;
        :) printf "missing argument for -%s\n" "$OPTARG" >&2; echo "$USAGE" >&2; exit 1;;
        \?) printf "illegal option: -%s\n" "$OPTARG" >&2; echo "$USAGE" >&2; exit 1;;
    esac
done

if ((OPTIND == 1)); then
    echo "No options specified; fatal error" >&2
    exit 1
fi

if [[ -z ${NUM+x} || -z ${MINMDP+x} || -z ${HEATMDP+x} || -z ${EQUMDP+x} || -z ${PRODMDP+x} || -z ${COORDFILE+x} || -z ${DIMENSIONS+x} ]]; then
    echo "Missing options; fatal error" >&2
    echo "$USAGE" >&2
    exit 1
fi

# check for relative or absolute path and adjust to absolute path if needed
if [[ ! $MINMDP =~ "^/" ]]; then
    MINMDP=$PWD/$MINMDP
fi

if [[ ! -f $MINMDP ]]; then
    echo "MDP file: $MINMDP does not exist" >&2
    exit 1
elif [[ ! $MINMDP =~ .mdp$ ]]; then
    echo "file passed using m option is not an mdp file" >&2
    exit 1
fi

if [[ ! $HEATMDP =~ ^/ ]]; then
    HEATMDP=$PWD/$HEATMDP
fi

if [[ ! -f $HEATMDP ]]; then
    echo "MDP file: $HEATMDP does not exist" >&2
    exit 1
elif [[ ! $HEATMDP =~ .mdp$ ]]; then
    echo "file passed using t option is not an mdp file" >&2
    exit 1
fi

if [[ ! $EQUMDP =~ "^/" ]]; then
    EQUMDP=$PWD/$EQUMDP
fi

if [[ ! -f $EQUMDP ]]; then
    echo "MDP file: $EQUMDP does not exist" >&2
    exit 1
elif [[ ! $EQUMDP =~ .mdp$ ]]; then
    echo "file passed using e option is not an mdp file" >&2
    exit 1
fi

if [[ ! $PRODMDP =~ ^/ ]]; then
    PRODMDP=$PWD/$PRODMDP
fi

if [[ ! -f $PRODMDP ]]; then
    echo "MDP file: $PRODMDP does not exist" >&2
    exit 1
elif [[ ! $PRODMDP =~ .mdp$ ]]; then
    echo "file passed using p option is not an mdp file" >&2
    exit 1
fi

if [[ ! $COORDFILE =~ ^/ ]]; then
    COORDFILE=$PWD/$COORDFILE
fi

if [[ ! -f $COORDFILE ]]; then
    echo "MDP file: $COORDFILE does not exist" >&2
    exit 1
elif [[ ! $COORDFILE =~ .pdb$ ]]; then
    echo "file passed using c option is not an pdb file" >&2
    exit 1
fi

shift $((OPTIND - 1))

if  ! (($# == 0)); then
    echo "Positional arguments specified; fatal error" >&2
    echo "$USAGE"
    exit 1
fi  

if [[ $NUM -lt 1 ]]; then
    echo "-n option must be greater 0" >&2
    exit 1
fi

if [[ ${#DIMENSIONS[@]} -ne 3 ]]; then
    echo "-d option must have three elements" >&2
    exit 1
fi

for ((z=0; z < ${#DIMENSIONS[@]}; z++)); do
    if [[ $(bc -l <<< "${DIMENSIONS[$z]} < 0") -eq 1 ]]; then
        echo "-d option must be all positive" >&2
        exit 1
    fi
done

##############################################################################################################################################
## RUN DIR CREATION
##############################################################################################################################################

DIRNAME="$(date '+%d-%m-%Y-%H:%M:%S')"
mkdir /u/sa/br/pskeps/scratch/Grom_Results_Files/"$DIRNAME"
cd /u/sa/br/pskeps/scratch/Grom_Results_Files/"$DIRNAME" || exit

##############################################################################################################################################
## RUNSCRIPT GENERATION
##############################################################################################################################################

temp="${COORDFILE##/*/}"
TOP="${temp%%.*}.top"
unset temp
cat << EOF > runscript.batch
#!/bin/bash                                                                           
#SBATCH --job-name="GROMACSMINMPI"
#SBATCH --nodes=4                                                                 
#SBATCH --ntasks-per-node=36
#SBATCH --export=ALL
#SBATCH --exclusive   
#SBATCH --time=144:00:00
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err


#clear environment:
module purge 
#MPI:
module load compilers/gcc/9.3.1
module load mpi/openmpi/gcc/3.1.3
module load libs/fftw/gcc9-ompi/3.3.8
module load apps/gromacs/gcc-ompi/2021.1

# This line sets thread mapping.  Test for best value.
export KMP_AFFINITY=respect,verbose
export GMX_MAXBACKUP=-1

# Go to the directory from which our job was launched                                   
cd $SCRATCH/Grom_Results_Files/$DIRNAME
mkdir \$SLURM_JOBID
cd \$SLURM_JOBID

cp $MINMDP .
cp $HEATMDP .
cp $EQUMDP .
cp $PRODMDP .
cp $COORDFILE .
cp -r $FORCEF .

MINMDP=${MINMDP##/*/}
HEATMDP=${HEATMDP##/*/}
EQUMDP=${EQUMDP##/*/}
PRODMDP=${PRODMDP##/*/}
COORDFILE=${COORDFILE##/*/}

if [[ ! -f \$MINMDP || ! -f \$HEATMDP || ! -f \$EQUMDP || ! -f \$PRODMDP || ! -f \$COORDFILE ]]; then
    echo "full paths must be given to the scheduler" >&2
    exit 1
fi

# Create a short JOBID based on the one provided by the scheduler
JOBID=\$SLURM_JOBID

cat \$0 > runscript.\$JOBID
printenv > env.\$JOBID

export OMP_NUM_THREADS=1

# Run the job.
/sw/utility/local/tymer time_stamp "running job min"

# make tpr min file and top file and submit the job 
genInpGromacs \${MINMDP} \${COORDFILE} ${DIMENSIONS[*]} 
srun --mpi=pmi2 --nodes=4 --ntasks-per-node=36 mdrun_mpi -s -deffnm \${MINMDP%%.*} -c \${MINMDP%%.*}_out.gro

# tpr for heat file and submit job
/sw/utility/local/tymer time_stamp "running job heat"
genInpGromacs \${HEATMDP} \${MINMDP%%.*}_out.gro ${TOP}
srun --mpi=pmi2 --nodes=4 --ntasks-per-node=36 mdrun_mpi -s -deffnm \${HEATMDP%%.*} -c \${HEATMDP%%.*}_out.gro

# tpr for equ file and submit job 
/sw/utility/local/tymer time_stamp "running job equ"
genInpGromacs \${EQUMDP} \${HEATMDP%%.*}_out.gro ${TOP}
srun --mpi=pmi2 --nodes=4 --ntasks-per-node=36 mdrun_mpi -s -deffnm \${EQUMDP%%.*} -c \${EQUMDP%%.*}_out.gro

# tpr for prod file and submit job
/sw/utility/local/tymer time_stamp "running job prod"
genInpGromacs \${PRODMDP} \${EQUMDP%%.*}_out.gro ${TOP}
srun --mpi=pmi2 --nodes=4 --ntasks-per-node=36 mdrun_mpi -s -deffnm \${PRODMDP%%.*} -c \${PRODMDP%%.*}_out.gro -cpo \${PRODMDP%%.*}.cpt

# run has finished and exit
/sw/utility/local/tymer time_stamp "finished"

EOF

##############################################################################################################################################
## RUN AND EXIT
##############################################################################################################################################

for (( c=1; c<=NUM; c++ )); do 
    sbatch runscript.batch
done

rm runscript.batch
echo -e "\033[32mAll jobs are scheduled $DIRNAME\033[00m"