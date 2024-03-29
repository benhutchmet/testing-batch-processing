#!/bin/bash

# submit-all-multi-model.NAO-anom.bash
#
# Usage: submit-all-multi-model.NAO-anom.bash <model>
#
# For example: submit-all-multi-model.NAO-anom.bash BCC-CSM2-MR

# import the models list
source $PWD/models.bash
# echo the models list
echo "[INFO] Models list: $models"

USAGE_MESSAGE="Usage: submit-all-multi-model.NAO-anom.bash <model>"

# check that the correct number of arguments have been passed
if [ $# -ne 1 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# set the model
model=$1

# set the extractor
EXTRACTOR=$PWD/multi-model.NAO-anom.bash

# run the extractor for each model specified
if [ $model == "all" ]; then

    # echo the models list
    echo "[INFO] Calculating NAO anomalies for all models: $models"

    for model in $models; do

        # echo the model name
        echo "[INFO] Calculating NAO anomalies for model: $model"

        # set the output directory
        OUTPUTS_DIR=/work/scratch-nopw/benhutch/$model/lotus-output/

        # make the output directory if it doesn't exist
        mkdir -p $OUTPUTS_DIR

        # for each model, we only submit one job to LOTUS
        echo "[INFO] Submitting job to LOTUS to calculate NAO anomalies for $model"
        # Submit the job to LOTUS
        sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/model-mean-state.%j.out \
               -e $OUTPUTS_DIR/model-mean-state.%j.err $EXTRACTOR $model

    done

else

    # echo the model name
    echo "[INFO] Calculating NAO anomalies for model: $model"

    # set the output directory
    OUTPUTS_DIR=/work/scratch-nopw/benhutch/$model/lotus-output/

    # make the output directory if it doesn't exist
    mkdir -p $OUTPUTS_DIR

    # for each model, we only submit one job to LOTUS
    echo "[INFO] Submitting job to LOTUS to calculate NAO anomalies for $model"
    # Submit the job to LOTUS
    sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/model-mean-state.%j.out \
           -e $OUTPUTS_DIR/model-mean-state.%j.err $EXTRACTOR $model

fi