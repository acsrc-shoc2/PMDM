#!/bin/bash -le

# -l makes this a login shell so the NeSI arch module (NeSI/zen3) is
# initialised before `module load` runs. Without it this script only works
# when submitted from a session that already has modules loaded, such as an
# Open OnDemand terminal; submitted over plain ssh or from cron it fails with
# "JupyterLab ... cannot be loaded as requested" and papermill: command not found.

#SBATCH --time          0:10:00
#SBATCH --mem           20GB
#SBATCH --cpus-per-task 8
#SBATCH --account       uoa04517
#SBATCH --gres          gpu:pro_6000:1
#SBATCH --job-name      pmdm
#SBATCH --output        pmdm.log

module load JupyterLab/2026.7.0-foss-2026-4.6.0

# below is where kernel pmdm is located
export JUPYTER_PATH=/nesi/project/uoa04517/.jupyter/share/jupyter

papermill pmdm.ipynb output_pmdm.ipynb --kernel pmdm
