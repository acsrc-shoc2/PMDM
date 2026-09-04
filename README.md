# PMDM Local setup for https://github.com/Layne-Huang/PMDM for UoA.

- pmdm.def 			Apptainer def file to build container
- build_pmdm_container.sh	Generic bash script to build container
- build_pmdm_container.sl	SLURM script to run bash script with resourcing	
- build_pmdm_jupyter.sh		Create a Jupyter Kernel on REANNZ on demand (https://ondemand.nesi.org.nz/public/)
- run_pmdm_container.sl		Run PMDM non-interactively
- run_pmdm_jupyter.ipynb	Run PMDM interactiely

Notes:

## pmdm.def

Base image is 13.0.0-cudnn-devel-ubuntu22.04
Gets PMDM from https://github.com/Layne-Huang/PMDM.git
Has to patch some python as the original PMDM was committed in 2024, and development libraries have moved on since then.
Creates a conda environment for controlled installation of libraries

## build_pmdm_container.sh

Is designed as a generic bash script to work outside REANNZ if needs be.  A group ID is required so that the research group members can use a single instance.
Right now the group is set to GROUP_ID=uoa04517 as this is the REANNZ project id.
After building the container the folders data, logs and configs are created locally so that PMDM can make persistent changes to input/output
Note that for data, we could set output from crossdocked (https://github.com/Layne-Huang/PMDM#crossdocked), but Binding MOAD (https://github.com/Layne-Huang/PMDM#binding-moad) appears to be offline
The crossdocked data is large (1.6 GB), so the script checks if it has been already downloaded before trying again.  It also checks the download is complete
When the container is run, these folders should be mounted using the bind string generated in the file 'bind_syntax.txt'

## build_pmdm_container.sl

Is designed to run build_pmdm_container.sh with 60 GB of RAM, 8 Cores and 12 hours.  This is to decouple the process of building the container from running it on the HPC.

## run_pmdm_container.sh 

Is designed to run through the examples of PMDM from the github page (https://github.com/Layne-Huang/PMDM).  It is called by run_pmdm_container.sl

## build_pmdm_jupyter.sh

Is designed to create a REANNZ JupyterLab kernel from the above container so that PMDM can be run interactively.
After running, you should see a kernel in the Jupyter section of ondemand (https://ondemand.nesi.org.nz/public/)

## run_pmdm_jupyter.ipynb

A python notebook to run PMDM interactively using the REANNZ JupyterLab kernel
