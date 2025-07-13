# Creating a MESA Binary Star Grid Using POSYDON on HiPerGator

This guide provides step-by-step instructions for generating a grid of $\texttt{MESA}$ binary star models using the `posydon-setup-grid` command-line interface available in $\texttt{POSYDON}$.

## 1. Define the Parameter Space for your Models

First, create a `.csv` file that specifies the parameter space for your grid of models. This file defines the binary system parameters: the two component masses and the orbital period. The example Python script below can be run in a Jupyter Notebook to generate this file:

```
import numpy as np

M_star = np.linspace(0.7,0.8,2)
M_NS = np.linspace(1.5,1.6,2)
Porb = np.linspace(2.8,3.0,2)
met_solar = [0.45] # 2, 1, 0.45, 0.2, 0.1, 1e-2, 1e-3, 1e-4
met = [i*0.0142 for i in met_solar]

with open('grid_trial.csv','w') as f:
    print('m1'+","+'m2'+","+'initial_period_in_days'+","+'initial_z'+","+'Zbase',file=f)
    for i in M_star:
        for j in M_NS:
            for k in Porb:
                for l in met:
                   print(str(10**i)+","+str(j)+","+str(10**k)+","+'{:.3e}'.format(l)+","+'{:.3e}'.format(l),file=f)
```

It defines a parameter space with

- Primary star mass in the range $[10^{0.7}, 10^{0.8}]$ $\rm{M_\odot}$,
- Neutron star mass in the range $[1.5,1.6]$ $\rm{M_\odot}$,
- Orbital periods between $[10^{2.8}, 10^{3.0}]$ days,

The metallicity is set to $\rm{0.45\,Z_\odot}$, and converted to an absolute value of $\rm{Z}$. Since each of the parameters $M_1, M_2 \, \rm{and}$ $P_{\rm{orb}}$ is sampled with $2$ values, this configuration will result in a grid of $2\times2\times2=8$ $\texttt{MESA}$ models.

## 2. Create the Initialisation File

From the [Grid_Run_Template](../Grid_Run_Template) directory, download the `params.ini` file. In this file, ensure that the following line correctly specifies the POSYDON branch and commit hash:

> ```
> scenario = ['posydon', 'development-18710e943edd926a5653c4cdb7d6e18e5bdb35a2', 'CO-H_star']
> ```
- `development-...` indicates the $\texttt{POSYDON}$ Git branch and commit.
- `CO-H_star` refers to the scenario type: a compact object (CO) and a hydrogen-rich star.

Make sure the name of your parameter space file matches the one listed in the `.ini` file:

> ```
> grid = grid_trial.csv
> ```

## 3. Set the Environment Variables 

From your HiPerGator terminal, navigate to the directory containing both `params.ini` and `grid_trial.csv` files. Then, configure your environment for $\texttt{MESA}$:

```
export MESASDK_ROOT=/blue/jeffrey.andrews/mesasdk
source $MESASDK_ROOT/bin/mesasdk_init.sh
```

## 4. Launch the Grid

Now, we're ready to run the simulation with the following $\texttt{POSYDON}$ setup command:

```
posydon-setup-grid --grid-type fixed --inifile params.ini --submission-type slurm
```

This will generate a SLURM batch submission script named `job_array_grid_submit.slurm`. To launch your job array:

```
sbatch job_array_grid_submit.slurm 
```

This will begin running your $\texttt{MESA}$ models across the parameter space. You can monitor progress through the SLURM queue and log files.

Sit back and relax! In another tutorial, we'll learn how to combine these models into a $\texttt{POSYDON}$ binary star grid.
