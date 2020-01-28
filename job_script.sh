
#!/bin/bash

#$ -cwd
#$ -l rt_F=4
#$ -l h_rt=1:00:00
#$ -N ULTRASCALE
#$ -o ULTRA_out.log
#$ -e ULTRA_err.log

. /etc/profile.d/modules.sh
module load intel-mkl

      
source ~/.bashrc
module load openmpi
export STARPU_SCHED=dmda
export MKL_NUM_THREADS=1
make clean
make -j 10 h_lu
mpirun --mca mpi_cuda_support 0 -x LD_LIBRARY_PATH  -x STARPU_SCHED  -x MKL_NUM_THREADS  -N 1 -np 4 ./a.out 3 32768 2048 2 2
