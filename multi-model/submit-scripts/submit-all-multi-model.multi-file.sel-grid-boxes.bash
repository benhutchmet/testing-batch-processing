#!/bin/bash

# submit-all-multi-model.multi-file.sel-grid-boxes.bash
#
# Usage: submit-all-multi-model.multi-file.sel-grid-boxes.bash <location> <start_year> <finish_year> <model>
#
# For example: submit-all-multi-model.multi-file.sel-grid-boxes.bash azores 1960 1960 HadGEM3-GC31-MM
#
# set the partition/account arguments for LOTUS based on usage context
# SBATCH --partition=short-serial

# import the models list
source $PWD/models.bash
# echo the models list
echo "[INFO] multi-file models list: $multi_file_models"

# set the usage message
USAGE_MESSAGE="Usage: submit-all-multi-model.multi-file.sel-grid-boxes.bash <location> <start_year> <finish_year> <model>"

# check that the correct number of arguments have been passed
if [ $# -ne 4 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# extract the location
location=$1

# set the extractor script and the output directory
EXTRACTOR=$PWD/multi-model.multi-file.sel-grid-boxes.bash

# extract the start and finish years
start_year=$2
finish_year=$3

# extract the model name
model=$4

# if model=all, then run a for loop over all the models
if [ $model == "all" ]; then

    # set up the model list
    echo "[INFO] Extracting data for all multi-file models: $multi_file_models"

    # loop through the models
    for model in $multi_file_models; do

        # echo the model name
        echo "[INFO] Extracting data for model: $model"

        # set up the number of ensemble members to extract
        if [ $model == "HadGEM3-GC31-MM" ]; then
            run=10
        elif [ $model == "EC-Earth3" ]; then
            run=10
        else
            echo "[ERROR] Model not recognised"
            exit 1
        fi

        # echo the number of ensemble members
        echo "[INFO] Number of ensemble members: $run"

        # set the output directory
        OUTPUT_DIR=/work/scratch-nopw/benhutch/$model/$location/lotus-outputs
        # make the output directory
        mkdir -p $OUTPUT_DIR

        # loop through the years
        for year in $(seq $start_year $finish_year); do

            # echo the year
            echo "[INFO] Year: $year"

            # inner loop through the ensemble members
            for run in $(seq 1 $run); do

                # echo the ensemble member
                echo "[INFO] Ensemble member: $run"

                # set the date
                year=$(printf "%d" $year)
                run=$(printf "%d" $run)
                echo "[INFO] Submitting job to LOTUS for year: $year and run: $run"
                # Submit the job to LOTUS
                sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/${year}-${run}.%j.out \
                       -e $OUTPUTS_DIR/${year}-${run}.%j.err $EXTRACTOR $location $model $year $run

            done

        done

    done

# if model is not all, then run the script for the specified model
else

    # echo the model name
    echo "[INFO] Extracting data for model: $model"

    # set up the number of ensemble members to extract
    if [ $model == "HadGEM3-GC31-MM" ]; then
        run=10
    elif [ $model == "EC-Earth3" ]; then
        run=10
    else
        echo "[ERROR] Model not recognised"
        exit 1
    fi

    # echo the number of ensemble members
    echo "[INFO] Number of ensemble members: $run"

    # set the output directory
    OUTPUT_DIR=/work/scratch-nopw/benhutch/$model/$location/lotus-outputs
    # make the output directory
    mkdir -p $OUTPUT_DIR

    # loop through the years
    for year in $(seq $start_year $finish_year); do

        # echo the year
        echo "[INFO] Year: $year"

        # inner loop through the ensemble members
        for run in $(seq 1 $run); do

            # echo the ensemble member
            echo "[INFO] Ensemble member: $run"

            # set the date
            year=$(printf "%d" $year)
            run=$(printf "%d" $run)
            echo "[INFO] Submitting job to LOTUS for year: $year and run: $run"
            # Submit the job to LOTUS
            sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/${year}-${run}.%j.out \
                   -e $OUTPUTS_DIR/${year}-${run}.%j.err $EXTRACTOR $location $model $year $run

        done

    done

fi
