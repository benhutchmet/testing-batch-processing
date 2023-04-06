#!/bin/bash

# submit-all-multi-model.calc-bl.bash
#
# For example: submit-all-multi-model.calc-bl.bash azores BCC-CSM2-MR
#
# set the partition/account arguments for LOTUS based on usage context
# SBATCH --partition=short-serial

USAGE_MESSAGE="Usage: submit-all-multi-model.calc-bl.bash <location> <model>"

# check that the correct number of arguments have been passed
if [ $# -ne 2 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# extract the location and model
location=$1
model=$2

# set the extractor script
EXTRACTOR=$PWD/multi-model.calc-bl.bash

# set up the model list
models="BCC-CSM2-MR MPI-ESM1-2-HR CanESM5 CMCC-CM2-SR5"

# loop through the models
if [ $model == "all" ]; then

    for model in $models; do

        # echo the model name
        echo "[INFO] Calculating the model mean state for model: $model"

        # set the output directory
        OUTPUTS_DIR=/work/scratch-nopw/benhutch/$model/$location/lotus-outputs

        # make the output directory if it doesn't exist
        mkdir -p $OUTPUTS_DIR

        # we only have to submit one job to lotus
        echo "[INFO] Submitting job to LOTUS to calculate the model mean state for $model"

        # Submit the job to LOTUS
        sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/model-mean-state.%j.out \
               -e $OUTPUTS_DIR/model-mean-state.%j.err $EXTRACTOR $location $model

    done

else

       # set the output directory
       OUTPUTS_DIR=/work/scratch-nopw/benhutch/$model/$location/lotus-outputs
       # make the output directory if it doesn't exist
       mkdir -p $OUTPUTS_DIR

       # echo the model name
       echo "[INFO] Calculating the model mean state for model: $model"

       # we only have to submit one job to lotus
       echo "[INFO] Submitting job to LOTUS to calculate the model mean state for $model"

       # Submit the job to LOTUS
       sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/model-mean-state.%j.out \
              -e $OUTPUTS_DIR/model-mean-state.%j.err $EXTRACTOR $location $model

fi