# Submit all of the jobs to the batch cluster

#!/bin/bash

# submit-all-HadGEM.bash
#
# Usage:    submit-all-HadGEM.bash
#

# set the partition/account arguments for LOTUS based on usage context
# SBATCH --partition=short-serial

EXTRACTOR=$PWD/HadGEM_sellonlat_test.bash
OUTPUTS_DIR=/home/users/benhutch/batch-testing/lotus-outputs

# make the output directory if it doesn't exist
mkdir -p $OUTPUTS_DIR

# set the partition arguments
sbatch_part_cmds="--partition=short-serial"

# set the start and finish years
start_year=1960
finish_year=2018

# set the run
run=10 # we want all ensemble members

# set the lon/lat values for the azores
lon1=-28
lon2=-20
lat1=36
lat2=40

# set the location
location=azores

# create an outer loop to loop through the years
for year in $(seq $start_year $finish_year); do

    # set up the inner loop to loop through the ensemble members
    for run in $(seq 1 $run); do

        # set the date
        year=$(printf "%d" $year)
        run=$(printf "%d" $run)
        echo "[INFO] Submitting job to LOTUS for year: $year and run: $run"
        # Submit the job to LOTUS
        sbatch $sbatch_part_cmds -t 5 -o $OUTPUTS_DIR/${year}-${run}.%j.out \
               -e $OUTPUTS_DIR/${year}-${run}.%j.err $EXTRACTOR $year $run $lon1 $lon2 $lat1 $lat2 $location

    done

done

