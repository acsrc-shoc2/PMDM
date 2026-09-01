#!/bin/bash -e

#container I want converted
CONTAINER_NAME=pmdm.sif
KERNEL_NAME=${CONTAINER_NAME%.*}

#group/project I want to make data and the container accessible to
GROUP_ID=uoa04517

#folder I want the container to start in
PWD=/opt/PMDM

#BIND_STRING string to use to mount external folders inside the container
BIND_STRING=$(cat bind_syntax.txt)

# command to use a GPU with the container
GPU_REQUEST="--nv"

CONTAINER_ARGS="$GPU_REQUEST --pwd $PWD $BIND_STRING --shared -a $GROUP_ID"
CONTAINER_ARGS="$GPU_REQUEST --pwd $PWD $BIND_STRING"

#Add module to create a Jupyter kernel from the container
module purge
module load JupyterLab/2026.7.0-foss-2026-4.6.0

jupyter-kernelspec remove -y $KERNEL_NAME || true
nesi-add-kernel -cp $CONTAINER_NAME --container-args "$CONTAINER_ARGS" $KERNEL_NAME
