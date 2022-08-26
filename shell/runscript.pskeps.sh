#!/bin/bash                                                                           
#SBATCH --job-name="lammpsMPI"
#SBATCH --nodes=1                                                                   
#SBATCH --ntasks-per-node=16
#SBATCH --export=ALL   
#SBATCH --time=10:00:00


#clear environment:
module purge 
#MPI:
module load compilers/intel/2018
module load mpi/impi/2018-intel
module load apps/python2/2.7-intel-2018.3
module load apps/lammps

# This line sets thread mapping.  Test for best value.
export KMP_AFFINITY=respect,verbose

# Go to the directory from which our job was launched                                   
cd $SLURM_SUBMIT_DIR
echo $SLURM_SUBMIT_DIR
mkdir $SLURM_JOB_ID
cd $SLURM_JOB_ID
cp LAMMPS_Input_Files/$1 .
cp LAMMPS_Data_Files/$2 .
cp LAMMPS_Parameter_Files/$3 .

# Create a short JOBID based on the one provided by the scheduler
JOBID=`echo $SLURM_JOB_ID`

cat $0 > runscript.$JOBID
printenv > env.$JOBID

export OMP_NUM_THREADS=1

# run the job
# Below, change lmps.in to the name of your input file:
srun --mpi=pmi2 --nodes=1 --ntasks-per-node=16 lmp_mpi < $1 > output.$JOBID

