Version of externals_all used for XEM2 analysis and R-SIDIS. Uses F1F2IN21_v1.0 (courtesy Eric Christy) for p and d with a fit to the EMC effect for the inleastic cross section. Uses F1F209 (superscaling) for QE model.

# Radiative Corrections (externals_rsidis)

This repository contains the Fortran-based `externals_rsidis` code used for calculating radiative correction (RC) tables for experimental data analysis in Hall C at Jefferson Lab.

## 1. Compilation

You need to compile both the main physics executable and the grid generation script.


### Step 1. Compile the main physics calculations
```bash
cd externals_rsidis
make clean
make

```
 **Verify externals_all is created:**
```bash
ls externals_all

```
### Step 2. Compile the grid generator
```bash
cd make_grid
gfortran make_grid_rsidis.f

```
**Verify a.out is created:**
```bash
ls a.out

```
## 2. Directory Structure & Key Files

* **`externals_all`**: The main compiled executable that calculates the cross-sections.
* **`make_grid/a.out`**: Generates the raw kinematic grid files (momentum and angles).
* **`TARG/`**: Contains physical target parameters (radiation lengths, atomic number, etc.).
* **`RUNPLAN/`**: The staging directory where `.inp` configuration files are stored.
* **`OUT/`**: The output directory where the farm saves individual `.out` tables and where the final combined table is generated.
* **`SCRIPTS/`**: Contains bash scripts for generating input files, farm submission, and output combination.
* **`run_extern`**: A script used to execute the compiled code on a specific input file.

## 3. Testing Locally

Before submitting multiple jobs to the batch farm, you can test a minimal configuration locally to ensure the code compiles and reads your target files correctly.

> **⚠️ WARNING:** Do NOT run a full multi-angle grid on a local machine or interactive node. The physics calculations will take far too long.

1. **Verify Target File:** Ensure the correct configuration file for your physical target exists in the `TARG/` directory.
2. **Make a Tiny Grid:** Go to `make_grid` and run `./a.out`. Enter a very small range (e.g., just 1 angle bin and 1 momentum bin) so the code completes almost instantly.
3. **Generate the Input File:** Navigate to the `SCRIPTS/` directory and use the `make_input_files.sh` script to generate the `.inp` file for the tiny grid you just created in `make_grid`.
   ```bash
   cd ../SCRIPTS
   ./make_input_files.sh <ebeam> <targ> <min_angle> <num_angle> <workflow_name>
   ```
4. **Run the Test:** Execute the test locally using:
```bash
./run_extern <infile_name>

```


5. **Check Output:** Verify that the code finishes without errors and generates the expected output file (e.g., in the `runout/` or `OUT/` directory). If successful, you are ready for the batch farm.

## 4. Full Phase Space Generation (JLab Swif2 Farm)

To generate a complete RC table, you must define your full padded kinematic grid and submit the calculations to the JLab Swif2 batch system.

### Step 1: Verify Target Configuration

Ensure your specific target file (e.g., `h2cryo_hms`) is correctly defined in the `TARG/` directory.

### Step 2: Generate the Full Grid

Navigate to the `make_grid/` directory to define the padded phase space.

```bash
cd make_grid
./a.out

```

*You will be prompted to enter beam energy, minimum/maximum scattered electron energy, energy step size, min/max angle, and angle step size.*

### Step 3: Submit to the Farm

The submission script (`do_farmsubmission_rsidis.sh`) has the built-in ability to auto-generate all required `.inp` files based on your grid and submit the jobs to Swif2.

```bash
cd ../SCRIPTS
./do_farmsubmission_rsidis.sh <ebeam> <targ> <min_angle> <num_angle> <workflow_name>

```

* **`<ebeam>`**: Beam energy (e.g., `8.607`).
* **`<targ>`**: Target filename prefix located in `TARG/` (e.g., `h2cryo_hms`).
* **`<min_angle>`**: The starting angle of your grid (e.g., `10.0`).
* **`<num_angle>`**: Total number of angle steps (e.g., `100`).
* **`<workflow_name>`**: A custom identifier for your batch (e.g., `my_4pass_run`). Using a unique prefix prevents your script from accidentally canceling your previous job.

### Step 4: Monitor Jobs

Check the status of your jobs in the Swif2 queue:

```bash
swif2 status externals_<workflow_name>_<targ>

```

Wait until all jobs show as `succeeded`. The individual angle calculations will automatically save to the `OUT/` directory.

## 5. Combining the Outputs

Once all Swif2 jobs have successfully finished, stitch the individual angle files into one master radiative correction table.

```bash
cd SCRIPTS
./combine_output.sh <targ> <min_angle> <num_angle> <workflow_name>

```

*Note: You must pass the exact same arguments used during the farm submission step.*

**Final Output:** The script concatenates the files sequentially and saves the final master table as `OUT/<workflow_name>_<targ>.out`.

