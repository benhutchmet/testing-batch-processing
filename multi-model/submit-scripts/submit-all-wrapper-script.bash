#!/bin/bash

# submit-all-wrapper-script.bash
#
# Usage: submit-all-wrapper-script.bash <model> <start-year> <finish-year>
#
# This script is a wrapper script for the submit-all scripts for the multi-model
#
# For example: submit-all-wrapper-script.bash BCC-CSM2-MR 1961 2014

USAGE_MESSAGE="Usage: submit-all-wrapper-script.bash <model> <start-year> <finish-year>"

# check that the correct number of arguments have been passed
if [ $# -ne 3 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# extract the model, start year and finish year
model=$1
start_year=$2
finish_year=$3

# set up the extractor
EXTRACTOR=$PWD/wrapper-script-calculate-nao.bash

# set up the models list
models="BCC-CSM2-MR MPI-ESM1-2-HR CanESM5 CMCC-CM2-SR5"

# run the extractor for each model specified
if [ $model == "all" ]; then

    for model in $models; do

        # echo the model name
        echo "[INFO] Calculating NAO for model: $model"

        # set the output directory
        OUTPUTS_DIR=/work/scratch-nopw/benhutch/lotus-output/multi-model/$model

        # make the output directory if it doesn't exist
        mkdir -p $OUTPUTS_DIR

        # for each model, we only submit one job to LOTUS
        echo "[INFO] Submitting job to LOTUS to calculate NAO for $model"
        # Submit the job to LOTUS
        sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/model-mean-state.%j.out \
               -e $OUTPUTS_DIR/model-mean-state.%j.err $EXTRACTOR $model $start_year $finish_year

    done

else

    # echo the model name
    echo "[INFO] Calculating NAO for model: $model"

    # set the output directory
    OUTPUTS_DIR=/work/scratch-nopw/benhutch/lotus-output/multi-model/$model

    # make the output directory if it doesn't exist
    mkdir -p $OUTPUTS_DIR

    # for each model, we only submit one job to LOTUS
    echo "[INFO] Submitting job to LOTUS to calculate NAO for $model"
    # Submit the job to LOTUS
    sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/model-mean-state.%j.out \
           -e $OUTPUTS_DIR/model-mean-state.%j.err $EXTRACTOR $model $start_year $finish_year

fi 

