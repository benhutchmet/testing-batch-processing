#!/bin/bash

# submit-all-multi-model.bash
#
# Usage: submit-all-multi-model.bash <location> <start_year> <finish_year> <model>
#
# For example: submit-all-multi-model.bash azores 1960 1969 BCC-CSM2-MR

# set the partition/account arguments for LOTUS based on usage context
# SBATCH --partition=short-serial

# extract the location
location=$1

# set the extractor script and the output directory
EXTRACTOR=$PWD/multi-model.sel-grid-boxes.bash

# extract the start and finish years
start_year=$2
finish_year=$3

# extract the model name
model=$4

# if model=all, then run a for loop over all the models
if [ $model == "all" ]; then

    # set up the model list
    models="BCC-CSM2-MR MPI-ESM1-2-HR CanESM5 CMCC-CM2-SR5"

    # loop through the models
    for model in $models; do

        # echo the model name
        echo "[INFO] Extracting data for model: $model"

        # set up the number of ensemble members to extract
        if [ $model == "BCC-CSM2-MR" ]; then
            run=8
        elif [ $model == "MPI-ESM1-2-HR" ]; then
            run=10
        elif [ $model == "CanESM5" ]; then
            run=20
        elif [ $model == "CMCC-CM2-SR5" ]; then
            run=10
        fi

        # echo the number of ensemble members
        echo "[INFO] Number of ensemble members: $run"


        # set the output directory
        OUTPUTS_DIR=/work/scratch-nopw/benhutch/$model/$location/lotus-outputs

        # make the output directory if it doesn't exist
        mkdir -p $OUTPUTS_DIR

        # create an outer loop to loop through the years
        for year in $(seq $start_year $finish_year); do

            # set up the inner loop to loop through the ensemble members
            for run in $(seq 1 $run); do

                # set the date
                year=$(printf "%d" $year)
                run=$(printf "%d" $run)
                echo "[INFO] Submitting job to LOTUS for year: $year and run: $run"
                # Submit the job to LOTUS
                sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/${year}-${run}.%j.out \
                       -e $OUTPUTS_DIR/${year}-${run}.%j.err $EXTRACTOR $year $run $location $model

            done

        done

    done

else
    
        # echo the model name
        echo "[INFO] Extracting data for model: $model"

        # set up the output directory
        OUTPUTS_DIR=/work/scratch-nopw/benhutch/$model/$location/lotus-outputs

        # set up the number of ensemble members to extract
        if [ $model == "BCC-CSM2-MR" ]; then
            run=8
        elif [ $model == "MPI-ESM1-2-HR" ]; then
            run=10
        elif [ $model == "CanESM5" ]; then
            run=20
        elif [ $model == "CMCC-CM2-SR5" ]; then
            run=10
        fi

        # echo the number of ensemble members
        echo "[INFO] Number of ensemble members: $run"

        # make the output directory if it doesn't exist
        mkdir -p $OUTPUTS_DIR
    
        # create an outer loop to loop through the years
        for year in $(seq $start_year $finish_year); do
    
            # set up the inner loop to loop through the ensemble members
            for run in $(seq 1 $run); do
    
                # set the date
                year=$(printf "%d" $year)
                run=$(printf "%d" $run)
                echo "[INFO] Submitting job to LOTUS for year: $year and run: $run"
                # Submit the job to LOTUS
                sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/${year}-${run}.%j.out \
                    -e $OUTPUTS_DIR/${year}-${run}.%j.err $EXTRACTOR $year $run $location $model
    
            done
    
        done
    
fi








