#!/bin/bash -e

# Set up container to run PMDM
CONTAINER_NAME=pmdm.sif
GPU_REQUEST="--nv"
PWD=/opt/PMDM
BIND_STRING=$(cat bind_syntax.txt)
CONTAINER_ARGS="$GPU_REQUEST --pwd $PWD $BIND_STRING"

# Inference (https://github.com/Layne-Huang/PMDinference)
# Sample molecules for given customized pockets
# https://github.com/Layne-Huang/PMDM#sample-molecules-for-given-customized-pockets
apptainer exec $CONTAINER_ARGS $CONTAINER_NAME \
    python -u sample_for_pdb.py \
    --ckpt data/ckpt/500.pt \
    --pdb_path \
  data/crossdocked_pocket10/ACE_HUMAN_650_1230_0/1o86_A_rec_1o86_lpr_lig_tt_docked_1_pocket10.pdb \
    --num_atom 34 \
    --num_samples 10 \
    --sampling_type generalized

# Sample novel molecules given seed fragments
# https://github.com/Layne-Huang/PMDM#sample-novel-molecules-given-seed-fragments
apptainer exec $CONTAINER_ARGS $CONTAINER_NAME \
    python -u sample_frag.py \
      --ckpt data/ckpt/500.pt \
      --pdb_path data/crossdocked_pocket10/DPP4_PIG_39_766_0/2aj8_A_rec_2aj8_sc3_lig_tt_docked_1_pocket10.pdb \
      --mol_file data/crossdocked_pocket10/DPP4_PIG_39_766_0/2aj8_A_rec_2aj8_sc3_lig_tt_docked_1.sdf \
      --keep_index 19 20 21 22 23 24 25 \
      --num_atom 26 \
      --num_samples 10 \
      --sampling_type generalized

# Training (https://github.com/Layne-Huang/PMDM#training)
# Crossdocked, Bindin MOAD not available to download
apptainer exec $CONTAINER_ARGS $CONTAINER_NAME \
  python -u train.py --config configs/crossdock_epoch.yml

# Inference Sample molecules for all pockets in the test set
# https://github.com/Layne-Huang/PMDM#sample-molecules-for-all-pockets-in-the-test-set
apptainer exec $CONTAINER_ARGS $CONTAINER_NAME \
  python -u sample_batch.py --ckpt data/ckpt/500.pt --num_samples 10 --sampling_type generalized

