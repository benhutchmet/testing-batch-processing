#!/bin/bash

# submit-all-lagged-ensemble.bash
#
# For example: submit-all-lagged-ensemble.bash azores BCC-CSM2-MR 1961 1969
#

# import the models list
source $PWD/models.bash
echo "[INFO] Models list: $models"

USAGE_MESSAGE="Usage: submit-all-lagged-ensemble.bash <location> <model> <start_year> <end_year>"

# check that the correct number of arguments have been passed
if [ $# -ne 4 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# extract the location, model, start year and end year
location=$1
model=$2
start_year=$3
end_year=$4

# set the lagged ensemble script
LAGGED_ENSEMBLE=$PWD/lagged-ensemble.bash

# loop through the models
if [ $model == "all" ]; then

    # set up the model list
    echo "[INFO] Creating lagged ensembles for all models: $models"

    for model in $models; do

        # echo the model name
        echo "[INFO] Creating lagged ensembles for model: $model"

        # set the output directory
        OUTPUTS_DIR=/work/scratch-nopw/benhutch/$model/$location/lotus-outputs

        # make the output directory if it doesn't exist
        mkdir -p $OUTPUTS_DIR

       
