#!/bin/bash

export reps=100
for size in 200 250 300 350 400 450 500 550 600 650 700 750 800; do
  for P in 16 32 64; do
    size=$size sbatch -n $P < job_mpi.sh
  done
done
