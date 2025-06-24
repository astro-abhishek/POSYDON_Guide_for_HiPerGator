# Running a Binary Population Synthesis on HiPerGator

This tutorial provides step-by-step instructions for setting up and running a binary population at a single metallicity on HiPerGator using SLURM. While POSYDON offers a convenient command-line interface via `posydon-setup-popsyn`, it is important to understand how to manually configure and submit jobs using SLURM for our own understanding. This is exactly what you'll learn in this guide.

---

## 1. Setup

Begin by downloading the [Population_Run_Template](../Population_Run_Template) directory, which contains all necessary scripts to launch a population synthesis run on HiPerGator.

Modify the `params.ini` file to configure your run. Common parameters that are frequently modified include:

```
common_envelope_efficiency = 1.0  # Efficiency factor for energy conversion to eject the common envelope
common_envelope_option_for_lambda = 'lambda_from_grid_final_values'  # Energy contributions that go into calculation of lambda
common_envelope_option_after_succ_CEE = 'two_phases_stableMT'  # Treatment of post-CEE evolution
```

for the common envelope phase. To change the properties related to the supernova in your population run: 

```
mechanism = 'Sukhbold+16-engine'  # Model for core-collapse supernova
ECSN = 'Tauris+15'  # Model for electron-capture supernova
kick_normalisation = 'one_over_mass'  # Prescription for natal kicks imparted during the supernova explosion
```

Additional parameters you may want to modify:

```
number_of_binaries = 2_000_000  # Total number of binaries to simulate
primary_mass_scheme = 'Kroupa2001'  # Initial mass function for primary stars
```

The params.ini file in the above directory is for a binary population at solar metallicity. You can change the metallicity as well to get a population synthesis run at a different metallicity.

## 2. SLURM Submission Script

Once you're done with configuring your population synthesis run, take a look at the submission scripts that have been provided:

```
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
```

## 3. User-specific_changes

Make sure to update the following in your initialisation and SLURM scripts:

1. `params.ini`, `submit_script_run.sh` and `submit_script_merge.sh`:

Change the path above to point to your POSYDON installation.
> ```
>   PATH_TO_POSYDON = '/blue/jeffrey.andrews/abhishek/POSYDON/' 

2. `submit_script_run.sh` and `submit_script_merge.sh`:
Replace with your email address to receive SLURM job notifications.
> ```
>#SBATCH --mail-user=a.chattaraj@ufl.edu
> ```

## 4. Submitting the Run

Once all the above steps are complete, activate your POSYDON conda environment. Then launch your population synthesis job using:

``` 
sbatch submit_script_run.sh
```
This will submit your job as a SLURM job-array and create a `batches` directory containing the runs stored in batches. 

> [!TIP]
> Check the status of your job using (change to your username):
> ```
> squeue -u a.chattaraj
> ```

Once you're job is finished (you should receive an email), merge all batch files into a single .h5 file using:
``` 
sbatch submit_script_merge.sh
```

Now, you will have the single .h5 file which will contain all the binaries with the desired properties that you specified in the .ini file. 

## 5. Look into the Population

Go ahead and look into the population and check out different binary evolutionary channels, analyze different double compact object properties (DNS, BBH, NSBH), compute the distributions at different evolutioanry phases, or invent some new stuff for your special science case! 
