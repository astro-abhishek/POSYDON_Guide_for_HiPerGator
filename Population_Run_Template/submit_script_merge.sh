#!/bin/bash

#SBATCH --account=jeffrey.andrews
#SBATCH --partition=hpg-milan
#SBATCH --array=0-199
#SBATCH -t 48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --job-name=1e+00_Zsun
#SBATCH --output=run_pop.out
#SBATCH --error=run_pop.err    
#SBATCH --mail-type=ALL                                                                                                            
#SBATCH --mail-user=a.chattaraj@ufl.edu                                                                                                                                                                                                       

export PATH_TO_POSYDON=/blue/jeffrey.andrews/abhishek/POSYDON/
export PATH_TO_POSYDON_DATA=/blue/jeffrey.andrews/POSYDON_popsynth_data/v2/250520_newSNe/

date

srun python merge_metallicity.py 1.

date