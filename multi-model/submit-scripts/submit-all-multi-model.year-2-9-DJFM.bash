#!/bin/bash

# submit-all-multi-model.year-2-9.bash
#
# Usage: submit-all-multi-model.year-2-9.bash <location> <model>

# set the partition/account arguments for LOTUS based on usage context
# SBATCH --partition=short-serial

# define the usage message
USAGE_MESSAGE="Usage: submit-all-multi-model.year-2-9.bash <location> <model>"

# check the number of command-line arguments
if [ $# -ne 2 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# extract the location and model
location=$1
model=$2

# set the extractor script and the output directory
EXTRACTOR=$PWD/multi-model.year2-9-DJFM.bash

# make the output directory if it doesn't exist
mkdir -p $OUTPUTS_DIR

# set up the model list
models="BCC-CSM2-MR MPI-ESM1-2-HR CanESM5 CMCC-CM2-SR5"

# loop through the models
if [ $model == "all" ]; then

    for model in $models; do

        # echo the model name
        echo "[INFO] Extracting data for model: $model"

        # set the output directory
        OUTPUTS_DIR=/work/scratch-nopw/benhutch/$model/$location/lotus-outputs

        # make the output directory if it doesn't exist
        mkdir -p $OUTPUTS_DIR

        # we only have to submit one job to lotus
        echo "[INFO] Submitting job to LOTUS to constrain the data to years 2-9 DJFM for $model"

        # Submit the job to LOTUS
        sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/year-2-9.%j.out \
               -e $OUTPUTS_DIR/year-2-9.%j.err $EXTRACTOR $location

    done

else

       # set the output directory
       OUTPUTS_DIR=/work/scratch-nopw/benhutch/$model/$location/lotus-outputs
       # make the output directory if it doesn't exist
       mkdir -p $OUTPUTS_DIR

       # echo the model name
       echo "[INFO] Extracting data for model: $model"

       # we only have to submit one job to lotus
       echo "[INFO] Submitting job to LOTUS to constrain the data to years 2-9 DJFM for $model"
       
       # Submit the job to LOTUS
       sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/year-2-9.%j.out \
       -e $OUTPUTS_DIR/year-2-9.%j.err $EXTRACTOR $location

fi

