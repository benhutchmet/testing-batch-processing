#!/bin/bash

# submit-all-BCC-CSM2-MR.mergetime.bash
#
# Usage: submit-all-BCC-CSM2-MR.mergetime.bash <location>
#

# set the location
location=$1

# set the extractor script and the output directory
EXTRACTOR=$PWD/BCC-CSM2-MR.mergetime.bash
OUTPUTS_DIR=/home/users/benhutch/BCC-CSM2-MR/$location/lotus-outputs
# make the output directory if it doesn't exist
mkdir -p $OUTPUTS_DIR

# we only have to submit one job to lotus
echo "[INFO] Submitting job to LOTUS to merge the time series for BCC-CSM2-MR for location: $location"
# Submit the job to LOTUS
sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/mergetime.%j.out \
       -e $OUTPUTS_DIR/mergetime.%j.err $EXTRACTOR $location