#!/bin/bash

###########################
## Slurm Config
###########################
#SBATCH -t 24:00:00
#SBATCH -c 4
#SBATCH --mem=16G
###########################

# Run the batch job.
srun run.sh ${1} ${2} 1>${3}.out 2>${3}.err

