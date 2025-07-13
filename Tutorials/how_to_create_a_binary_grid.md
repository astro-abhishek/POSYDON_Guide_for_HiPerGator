# Running a Binary Population Synthesis on HiPerGator

This tutorial provides step-by-step instructions for setting up and running a binary population at a single metallicity on HiPerGator using SLURM. While POSYDON offers a convenient command-line interface via `posydon-setup-popsyn`, it is important to understand how to manually configure and submit jobs using SLURM for our own understanding. This is exactly what you'll learn in this guide.

## 1. Population setup

Begin by downloading the [Population_Run_Template](../Population_Run_Template) directory, which contains all necessary scripts to launch a population synthesis run on HiPerGator.

Modify the `params.ini` file to configure your run. Common parameters that are frequently modified include:

- `common_envelope_efficiency = 1.0`: Efficiency factor for energy conversion to eject the common envelope.
- `common_envelope_option_for_lambda = 'lambda_from_grid_final_values'`: Energy contributions that go into calculation of lambda, the binding energy parameter.
- `common_envelope_option_after_succ_CEE = 'two_phases_stableMT'`: Treatment of post-CEE evolution.

for the common envelope phase. To change the supernova-related properties, modify: 

- `mechanism = 'Sukhbold+16-engine'`: Model for core-collapse supernova.
- `ECSN = 'Tauris+15'`: Model for electron-capture supernova.
- `kick_normalisation = 'one_over_mass'`: Prescription for natal kicks imparted during the supernova explosion.

Additional parameters you may want to modify:

- `number_of_binaries = 2_000_000`: Total number of binaries to simulate.
- `primary_mass_scheme = 'Kroupa2001'`: Initial mass function for primary stars.

The `params.ini` file in the template directory is configured for a binary population at solar metallicity. You can modify the `metallicity` parameter as well to synthesize a population at a different metallicity.

## 2. SLURM submission script

Once you're done with configuring your population synthesis run, take a look at the submission scripts that have been provided within the template directory:

```
#SBATCH --account=jeffrey.andrews
#SBATCH --partition=hpg-milan
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --array=0-199
#SBATCH -t 48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --job-name=1e+00_Zsun
#SBATCH --output=run_pop_%A_%a.out
#SBATCH --error=run_pop_%A_%a.err                                                                                   
#SBATCH --mail-type=ALL                                                                                     
#SBATCH --mail-user=a.chattaraj@ufl.edu
```

Here's a breakdown of what some of these lines do:
- `#SBATCH --partition=hpg-milan` tells you the name of the partition on HiPerGator on which your job will run. 
- `#SBATCH -N 1` requests 1 compute node.
- `#SBATCH --ntasks=1` and `#SBATCH --cpus-per-task=1` requests 1 task and allocates 1 CPU core per task (giving you a total of 1 CPU core).
- `#SBATCH --array=0-199` creates a job array of 200 separate jobs indexed from 0 to 199.
- `#SBATCH -t 48:00:00` sets the wall time limit according to your needs. 
- `#SBATCH --mem-per-cpu=8G` allocates 8 GB of memory per CPU core.
- `#SBATCH --job-name=1e+00_Zsun` sets a name for the job (e.g., indicating solar metallicity), which appears in job monitoring tools. 
- `#SBATCH --output=run_pop.out` and `#SBATCH --error=run_pop.err` redirects the standard output and standard error of the job to uniquely named files. `%A` is replaced by the master job ID and `%a` by the array index. So for job ID `123456` with array index `42`, the output file would be: `run_pop_123456_42.out`.

## 3. User-specific changes

Make sure to update the following in your initialisation and SLURM scripts:

1. `params.ini`, `submit_script_run.sh` and `submit_script_merge.sh`:

Change the path below to point to your POSYDON installation.
> ```
>   PATH_TO_POSYDON = '/blue/jeffrey.andrews/abhishek/POSYDON/' 
> ```

2. `submit_script_run.sh` and `submit_script_merge.sh`:

Replace with your email address to receive SLURM job notifications.
> ```
> #SBATCH --mail-user=a.chattaraj@ufl.edu
> ```

## 4. Submitting the run

Once all the above steps are complete, activate your POSYDON conda environment and launch the run using:

``` 
sbatch submit_script_run.sh
```
This will submit your job as a SLURM job-array and create a `batches/` directory containing the runs stored in different batches. 

> 💡 **Tip**: Check the status of your job using (change to your username):
> ```
> squeue -u a.chattaraj
> ```

Once you're job is finished (you should receive an email), merge all batch files into a single .h5 file using:
``` 
sbatch submit_script_merge.sh
```

Now, you will have a single merged file which will contain all the binaries with the desired properties that you specified in the `params.ini` file. 

## 5. Look into the population

Go ahead and explore the population! You can:
- Chcek out different binary evolution channels
- Analyze different double compact object properties (DNS, BBH, NSBH)
- Visualize the distributions at different evolutionary phases

Feel free to invent some new tools or scripts tailored to your special science case! 
