#!/bin/bash -l
#
#SBATCH --job-name="statistics"
#SBATCH --time=1:00:00
##SBATCH --nodes=4
##SBATCH --ntasks-per-node=13
#SBATCH --mem=8000
#SBATCH --reservation=sccs
#SBATCH --partition=long
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-core=1
#SBATCH --ntasks-per-node=36
##SBATCH --nodelist=ault01,ault02
#SBATCH --exclusive
#SBATCH --hint=nomultithread
#SBATCH --exclude=ault03
#SBATCH --error=lulesh.%A.e
#SBATCH --output=lulesh.%A.o

module load openmpi

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export SLURM_CPU_BIND=VERBOSE
export OMP_PLACES=cores
export OMP_PROC_BIND=close 

echo "MPI ranks: ${SLURM_NTASKS}"
echo "Threads: ${SLURM_NTASKS_PER_CORE}"
echo "PerNode: ${SLURM_NTASKS_PER_NODE}"
echo "Nodes: ${SLURM_JOB_NUM_NODES} Tasks: ${SLURM_NTASKS}"
echo "Nodes: ${SLURM_JOB_NODELIST}"

echo "Bind Type: ${SLURM_CPU_BIND_TYPE}"
echo "Bind List: ${SLURM_CPU_BIND_LIST}"
echo "OpenMP places: ${OMP_PLACES}"

# User configuration
DIRECTORY=/users/mcopik/projects/rdma/repo/tests_dgemm/results_mpi_classic_new
export SERVERS_DB=/users/mcopik/projects/rdma/repo/tests_lulesh/servers.json

mkdir -p $DIRECTORY
cd $DIRECTORY
srun --accel-bind=v --cpu-bind=cores,verbose -n ${SLURM_NTASKS} ../mpi_classic ${size} ${reps} mpi_classic_${SLURM_NTASKS}_${size}_${reps}.csv > result_${size}_${SLURM_NTASKS} 2>&1

