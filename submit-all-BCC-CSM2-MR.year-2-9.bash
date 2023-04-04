#!/bin/bash

# submit-all-BCC-CSM2-MR.year-2-9.bash
#
# Usage: submit-all-BCC-CSM2-MR.year-2-9.bash <location>

# set the partition/account arguments for LOTUS based on usage context
# SBATCH --partition=short-serial

# extract the location
location=$1

# set the extractor script and the output directory
EXTRACTOR=$PWD/BCC-CSM2-MR.year-2-9.test.bash
OUTPUTS_DIR=/home/users/benhutch/BCC-CSM2-MR/$location/lotus-outputs

# make the output directory if it doesn't exist
mkdir -p $OUTPUTS_DIR

# we only have to submit one job to lotus
echo "[INFO] Submitting job to LOTUS to constrain the data to years 2-9 for BCC-CSM2-MR"
# Submit the job to LOTUS
sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/year-2-9.%j.out \
       -e $OUTPUTS_DIR/year-2-9.%j.err $EXTRACTOR $location

