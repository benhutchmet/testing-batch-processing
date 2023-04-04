#!/bin/bash

# submit-all-BCC-CSM2-MR.sub_MM.bash
#
# Usage: submit-all-BCC-CSM2-MR.sub_MM.bash <location> <start_year> <finish_year>

# set the partition/account arguments for LOTUS based on usage context
# SBATCH --partition=short-serial

# extract the location
location=$1

# extract the start and finish years
start_year=$2
finish_year=$3

# set the extractor script and the output directory
EXTRACTOR=$PWD/BCC-CSM2-MR.sub_MM.bash
OUTPUTS_DIR=/home/users/benhutch/BCC-CSM2-MR/$location/lotus-outputs

# make the output directory if it doesn't exist
mkdir -p $OUTPUTS_DIR

# create an outer loop to loop through the years
for year in $(seq $start_year $finish_year); do

    # set the date
    year=$(printf "%d" $year)
    echo "[INFO] Submitting job to LOTUS for year: $year"
    # Submit the job to LOTUS
    sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/${year}.%j.out \
           -e $OUTPUTS_DIR/${year}.%j.err $EXTRACTOR $location $year

done
