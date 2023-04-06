#!/bin/bash

# submit-all-multi-model.combine_anom.bash
#
# For example: submit-all-multi-model.combine_anom.bash azores BCC-CSM2-MR 1961 1969
#

USAGE_MESSAGE="Usage: submit-all-multi-model.combine_anom.bash <location> <model> <start_year> <finish_year>"

# check that the correct number of arguments have been passed
if [ $# -ne 4 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# extract the location, model, start year and finish year
location=$1
model=$2
start_year=$3
finish_year=$4

# set the extractor script
EXTRACTOR=$PWD/multi-model.combine_anom.bash

# set up the models list
models="BCC-CSM2-MR MPI-ESM1-2-HR CanESM5 CMCC-CM2-SR5"

# loop through the models
if [ $model == "all" ]; then

    for model in $models; do

        # echo the model name
        echo "[INFO] Combining anomalies for model: $model"

        # set the output directory
        OUTPUTS_DIR=/work/scratch-nopw/benhutch/$model/$location/lotus-outputs

        # make the output directory if it doesn't exist
        mkdir -p $OUTPUTS_DIR

        # create an outer loop to loop through the years
        for year in $(seq $start_year $finish_year); do

            # set the date
            year=$(printf "%d" $year)
            echo "[INFO] Submitting job to LOTUS for year: $year"
            # Submit the job to LOTUS
            sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/${year}.%j.out \
                   -e $OUTPUTS_DIR/${year}.%j.err $EXTRACTOR $location $model $year

        done

    done

else

    # echo the model name
    echo "[INFO] Combining anomalies for model: $model"

    # set the output directory
    OUTPUTS_DIR=/work/scratch-nopw/benhutch/$model/$location/lotus-outputs

    # make the output directory if it doesn't exist
    mkdir -p $OUTPUTS_DIR

    # create an outer loop to loop through the years
    for year in $(seq $start_year $finish_year); do

        # set the date
        year=$(printf "%d" $year)
        echo "[INFO] Submitting job to LOTUS for year: $year"
        # Submit the job to LOTUS
        sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/${year}.%j.out \
               -e $OUTPUTS_DIR/${year}.%j.err $EXTRACTOR $location $model $year

    done

fi