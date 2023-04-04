# submit all of the jobs to the batch cluster

#!/bin/bash

# submit-all-BCC-CSM2-MR.bash
#
# Usage:    submit-all-BCC-CSM2-MR.bash <location> <start_year> <finish_year> <lon1> <lon2> <lat1> <lat2>

# set the partition/account arguments for LOTUS based on usage context
# SBATCH --partition=short-serial

# extract the location
location=$1

# set the extractor script and the output directory
EXTRACTOR=$PWD/BCC-CSM2-MR.sel-grid-boxes.bash
OUTPUTS_DIR=/home/users/benhutch/BCC-CSM2-MR/$location/lotus-outputs
# make the output directory if it doesn't exist
mkdir -p $OUTPUTS_DIR

# extract the start and finish years
start_year=$2
finish_year=$3

# set the number of ensemble members to extract
run=8 # we want all ensemble members

# extract the lon/lat values for the azores
lon1=$4
lon2=$5
lat1=$6
lat2=$7

# create an outer loop to loop through the years
for year in $(seq $start_year $finish_year); do

    # set up the inner loop to loop through the ensemble members
    for run in $(seq 1 $run); do

        # set the date
        year=$(printf "%d" $year)
        run=$(printf "%d" $run)
        echo "[INFO] Submitting job to LOTUS for year: $year and run: $run"
        # Submit the job to LOTUS
        sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/${year}-${run}.%j.out \
               -e $OUTPUTS_DIR/${year}-${run}.%j.err $EXTRACTOR $year $run $lon1 $lon2 $lat1 $lat2 $location

    done

done




