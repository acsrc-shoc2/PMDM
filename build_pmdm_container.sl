#!/bin/bash -e

#SBATCH --time          02:00:00
#SBATCH --mem           60GB
#SBATCH --cpus-per-task 8
#SBATCH --account       uoa04517
#SBATCH --job-name      build_pmdm_container
#SBATCH --output	build_pmdm_container.log

./build_pmdm_container.sh
