#!/bin/bash
#
# submit-all-multi-model.merge-multi-file.bash
#
# For example: submit-all-multi-model.merge-multi-file.bash HadGEM3-GC31-MM 1960 1969
#

USAGE_MESSAGE="Usage: submit-all-multi-model.merge-multi-file.bash <model> <initial-year> <final-year>"

# check that the correct number of arguments have been passed
if [ $# -ne 3 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# extract the model, initial year and final year
model=$1
initial_year=$2
final_year=$3

# specify the initialization method
# 1 in this case
# ---ASK DOUG ABOUT THIS---
init=1

# set the extractor script
EXTRACTOR=$PWD/multi-model.merge-multi-file.bash

# set up the model list
models="EC-Earth3 HadGEM3-GC31-MM"

# run the extractor script for each model
if [ $model == "all" ]; then

    for model in $models; do

        echo "[INFO] Submitting jobs for $model"

        # set the number of ensemble members
        if [ $model == "HadGEM3-GC31-MM" ]; then
            run=10
        elif [ $model == "EC-Earth3" ]; then
            run=10
        else
            echo "[ERROR] No. of ensemble members not known for $model"
            exit 1
        fi

        # echo the no. of ens members
        echo "[INFO] No. of ensemble members: $run"

        # set the output directory
        OUTPUT_DIR=/work/scratch-nopw/benhutch/$model/lotus-outputs/
        # make the output directory if it doesn't exist
        mkdir -p $OUTPUT_DIR

        for year in $(seq $initial_year $final_year); do
            
        # echo the year
        echo "[INFO] Year being processed: $year"

            # loop over the ensemble members
            for run in $(seq 1 $run); do
                
                # set the date
                year=$(printf "%d" $year)
                run=$(printf "%d" $run)
                init=$(printf "%d" $init)
                echo "[INFO] Submitting job for $model, s$year, r$run, i$init"

                # submit the job to LOTUS
                sbatch --partition=short-serial -t 5 -o $OUTPUT_DIR/$model-s$year-r$run-i$init.out $EXTRACTOR $model $year $run $init

            done
        done
    done
else
    
    # echo the model name
    echo "[INFO] Submitting jobs for $model"

    # set up the output directory
    OUTPUT_DIR=/work/scratch-nopw/benhutch/$model/lotus-outputs/
    # make the output directory if it doesn't exist
    mkdir -p $OUTPUT_DIR

    # set the number of ensemble members
    if [ $model == "HadGEM3-GC31-MM" ]; then
        run=10
    elif [ $model == "EC-Earth3" ]; then
        run=10
    else
        echo "[ERROR] No. of ensemble members not known for $model"
        exit 1
    fi

    # echo the no. of ens members
    echo "[INFO] No. of ensemble members: $run"

    # create an outer loop to loop through the years
    for year in $(seq $initial_year $final_year); do
        
        # echo the year
        echo "[INFO] Year being processed: $year"

        # loop over the ensemble members
        for run in $(seq 1 $run); do
            
            # set the date
            year=$(printf "%d" $year)
            run=$(printf "%d" $run)
            init=$(printf "%d" $init)
            echo "[INFO] Submitting job for $model, s$year, r$run, i$init"

            # submit the job to LOTUS
            sbatch --partition=short-serial -t 5 -o $OUTPUT_DIR/$model-s$year-r$run-i$init.out $EXTRACTOR $model $year $run $init

        done
    done
fi 

