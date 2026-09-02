#!/bin/bash -e

#SBATCH --time          02:00:00
#SBATCH --mem           60GB
#SBATCH --cpus-per-task 8
#SBATCH --account       uoa04517
#SBATCH --gres		gpu:H100:1
#SBATCH --job-name      run_pmdm_container
#SBATCH --output        run_pmdm_container.log

./run_pmdm_container.sh
