#!/bin/bash -e

#location to install container and folders to
PROJDIR=/nesi/project/uoa04517/SHOC2/PMDM
cd $PROJDIR

#group/project I want to make data and the container accessible to
GROUP_ID=uoa04517

#Set up cache folders
unset APPTAINER_BIND
APPTAINER_CACHEDIR=$(mktemp -d)
APPTAINER_TMPDIR=${APPTAINER_CACHEDIR}

#Build container 
apptainer build --force pmdm.sif pmdm.def
chmod 640 pmdm.sif

# pmdm.sif should also be available via
# apptainer pull pmdm.sif oras://ghcr.io/acsrc-shoc2/pmdm/pmdm:latest

#Create data folder that PMDM can read/write to
DIR="/opt/PMDM/data"
BIND_STRING=""
LOCAL_DIR=$(basename $DIR)
FULL_LOCAL=$(readlink -f $LOCAL_DIR)
if [ ! -d $LOCAL_DIR ]; then
  echo "folder $LOCAL_DIR does not exist outside container, creating at $FULL_LOCAL"
  mkdir $FULL_LOCAL
  wget -P $LOCAL_DIR https://zenodo.org/records/10630921/files/split_by_name.pt
  wget -P $LOCAL_DIR https://zenodo.org/records/10630921/files/Results.zip
  FILE=crossdocked_pocket10.tar.gz
  if [ ! -f "$FILE" ]; then
      wget -c https://zenodo.org/records/10630921/files/crossdocked_pocket10.tar.gz -O "$FILE"
  fi
  EXPECTED_MD5=59416d06c2c366f6e05b91fdff8584f7 #https://zenodo.org/records/10630921
  ACTUAL_MD5=$(md5sum "$FILE" | awk '{print $1}')
  if [ "$ACTUAL_MD5" != "$EXPECTED_MD5" ]; then
     echo "ERROR: checksum mismatch after download (expected $EXPECTED_MD5, got $ACTUAL_MD5)" >&2
     exit 1
  fi
  tar -xzvf $FILE -C $LOCAL_DIR
  wget https://zenodo.org/records/10630921/files/500.pt 
  mkdir $FULL_LOCAL/ckpt
  cp 500.pt $LOCAL_DIR/ckpt/
  chgrp -R $GROUP_ID $LOCAL_DIR
  chmod -R g+rwX $LOCAL_DIR
fi
BIND_STRING="${BIND_STRING} -B ${FULL_LOCAL}:${DIR}"

#Create log folder that PMDM can write to
DIR="/opt/PMDM/logs"
LOCAL_DIR=$(basename $DIR)
FULL_LOCAL=$(readlink -f $LOCAL_DIR)
if [ ! -d $LOCAL_DIR ]; then
  echo "folder $LOCAL_DIR does not exist outside container, creating at $FULL_LOCAL"
  mkdir $FULL_LOCAL
  chgrp -R $GROUP_ID $LOCAL_DIR
  chmod -R g+rwX $LOCAL_DIR
fi
BIND_STRING="${BIND_STRING} -B ${FULL_LOCAL}:${DIR}"

#Create config folder that PMDM can read/write to
DIR="/opt/PMDM/configs"
LOCAL_DIR=$(basename $DIR)
FULL_LOCAL=$(readlink -f $LOCAL_DIR)
if [ ! -d $LOCAL_DIR ]; then
  echo "folder $LOCAL_DIR does not exist outside container, creating at $FULL_LOCAL"
  apptainer exec pmdm.sif cp -r $DIR $LOCAL_DIR
  chgrp -R $GROUP_ID $LOCAL_DIR
  chmod -R g+rwX $LOCAL_DIR
fi
BIND_STRING="${BIND_STRING} -B ${FULL_LOCAL}:${DIR}"

module load JupyterLab/2026.7.0-foss-2026-4.6.0
APPTAINER_DIR=/opt/PMDM

rm -rf /nesi/project/uoa04517/.jupyter/share/jupyter/kernels/pmdm
nesi-add-kernel pmdm -cp pmdm.sif --container-args="--nv --pwd $APPTAINER_DIR $BIND_STRING" --shared -a $GROUP_ID

echo To bind local folders to inside container, use the following:
echo $BIND_STRING
echo $BIND_STRING > bind_syntax.txt
