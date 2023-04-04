#!/bin/bash

# submit-all-BCC-CSM2-MR.NAO-anom.bash
#
# Usage: submit-all-BCC-CSM2-MR.NAO-anom.bash
#

# set the extractor script and the output directory
EXTRACTOR=$PWD/BCC-CSM2-MR.NAO-anom.bash
OUTPUTS_DIR=/home/users/benhutch/BCC-CSM2-MR/NAO_anomaly/lotus-outputs
# make the output directory if it doesn't exist
mkdir -p $OUTPUTS_DIR

# we only have to submit one job to lotus
echo "[INFO] Submitting job to LOTUS to calculate the NAO anomaly for BCC-CSM2-MR"
# Submit the job to LOTUS
sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/NAO-anom.%j.out \
       -e $OUTPUTS_DIR/NAO-anom.%j.err $EXTRACTOR