# PMDM

Codebase for SHOC2 containerised version of PMDM. Files:

- pmdm.def:	Apptainer definition file to build a container for pmdm
- build_pmdm.sh:Bash script to build pmdm container
- pmdm.ipynb:	Jupyter notebook to use pmdm interactively
- run_pmdm.sl:	SLURM script to run pmdm.ipynb non-interactively

Suggested usage:

1. Run ./build_pmdm.sh and make sure pmdm.sif is built
2. Goto https://ondemand.nesi.org.nz/public/ and select Jupyter Lab
    - Cluster: SLURM HPC
    - Project Code: uoa04517
    - JupyterLab Module: 2026.7.0-foss-2026-4.6.0
    - Number of Hours: 2
    - Number of Cores: 4
    - Memory per Job: 20 GB
    - GPU: L4
3. When Open Ondemand starts, choose the select the file 'pmdm.ipynb' from the chooser
4. Modify file to run your workflow
5. If you need to run for longer, or a GPU is not available, save changes in pmdm.ipynb, open a terminal kernel in Open Ondemand, and type:
6. sbatch run_pmdm.sl
