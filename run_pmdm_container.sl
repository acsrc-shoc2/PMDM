#!/bin/bash -e

#SBATCH --time          02:00:00
#SBATCH --mem           60GB
#SBATCH --cpus-per-task 8
#SBATCH --account       uoa04517
#SBATCH --gres		gpu:H100:1
#SBATCH --job-name      run_pmdm_container
#SBATCH --output        run_pmdm_container.log

CONTAINER_NAME=pmdm.sif

# command to use a GPU with the container
GPU_REQUEST="--nv"
#folder I want the container to start in
PWD=/opt/PMDM
#BIND_STRING string to use to mount external folders inside the container
BIND_STRING=$(cat bind_syntax.txt)
CONTAINER_ARGS="$GPU_REQUEST --pwd $PWD $BIND_STRING"

# Inference (https://github.com/Layne-Huang/PMDM#inference)
apptainer exec $CONTAINER_NAME $CONTAINER_ARGS python -u sample_batch.py --ckpt data/500.pt --num_samples 10 --sampling_type generalized

# Training (https://github.com/Layne-Huang/PMDM#training)
apptainer exec $CONTAINER_NAME $CONTAINER_ARGS python -u train.py --config configs/crossdock_epoch.yml

