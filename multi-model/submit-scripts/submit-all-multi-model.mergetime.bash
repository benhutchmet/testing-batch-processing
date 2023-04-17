#!/bin/bash

# submit-all-multi-model.mergetime.bash
#
# Usage: submit-all-multi-model.mergetime.bash <location> <model>
#

# import the models list
source $PWD/models.bash
# echo the models list
echo "[INFO] Models list: $models"

USAGE_MESSAGE="Usage: submit-all-multi-model.mergetime.bash <location> <model>"

# check that the correct number of arguments have been passed
if [ $# -ne 2 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# extract the location and model from the command line arguments
location=$1
model=$2

# set the extractor script and the output directory
EXTRACTOR=$PWD/multi-model.mergetime.bash

# make sure that cdo is loaded
module load jaspy

# loop through the models
if [ $model == "all" ]; then

    # set up the model list
    echo "[INFO] Merging the time dimension for model: $model"

    for model in $models; do

        # echo the model name
        echo "[INFO] Merging the time dimension for model: $model"

        # set the output directory
        OUTPUTS_DIR=/work/scratch-nopw/benhutch/$model/$location/lotus-outputs

        # make the output directory if it doesn't exist
        mkdir -p $OUTPUTS_DIR

        # we only have to submit one job to lotus
        echo "[INFO] Submitting job to LOTUS to merge the time dimension for $model"

        # Submit the job to LOTUS
        sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/merge-time-dimension.%j.out \
               -e $OUTPUTS_DIR/merge-time-dimension.%j.err $EXTRACTOR $location $model

    done

else

       # set the output directory
       OUTPUTS_DIR=/work/scratch-nopw/benhutch/$model/$location/lotus-outputs
       # make the output directory if it doesn't exist
       mkdir -p $OUTPUTS_DIR

       # we only have to submit one job to lotus
       echo "[INFO] Submitting job to LOTUS to merge the time dimension for $model"

       # Submit the job to LOTUS
       sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/merge-time-dimension.%j.out \
              -e $OUTPUTS_DIR/merge-time-dimension.%j.err $EXTRACTOR $location $model

fi