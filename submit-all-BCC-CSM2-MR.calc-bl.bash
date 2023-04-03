# submit all of the jobs to the batch cluster

#!/bin/bash

# submit-all-BCC-CSM2-MR.calc-bl.bash
#
# Usage:   submit-all-BCC-CSM2-MR.calc-bl.bash <location>
#

# set the partition/account arguments for LOTUS based on usage context
# SBATCH --partition=short-serial

# extract the location
location=$1

# set the extractor script and the output directory
EXTRACTOR=$PWD/BCC-CSM2-MR.calc-bl.bash
OUTPUTS_DIR=/home/users/benhutch/BCC-CSM2-MR/$location/lotus-outputs
# make the output directory if it doesn't exist
mkdir -p $OUTPUTS_DIR

# we only have to submit one job to lotus to calculate the model mean state
echo "[INFO] Submitting job to LOTUS to calculate the model mean state for BCC-CSM2-MR"
# Submit the job to LOTUS
sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/model-mean-state.%j.out \
       -e $OUTPUTS_DIR/model-mean-state.%j.err $EXTRACTOR $location



