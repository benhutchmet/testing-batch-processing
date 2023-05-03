#!/bin/bash

# submit-all-multi-model.lag-ens.ind-ens-members.bash
#
# Usage: submit-all-multi-model.lag-ens.ind-ens-members.bash <location> <model>
#
# Submit script for processing the lagged ensemble members for each individual ensemble member
# Processes all of the years available in the directory
# should be something like 1961-1964

# import the models list
source $PWD/models.bash
echo "[INFO] Models list: $models"

USAGE_MESSAGE="Usage: submit-all-multi-model.lag-ens.ind-ens-members.bash <location> <model>"

# check that the correct number of arguments have been passed
if [ $# -ne 2 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# extract the location and model
location=$1
model=$2

# set the extractor script
EXTRACTOR=$PWD/multi-model.lag-ens.ind-ens-members.bash

# loop through the models
if [ $model == "all" ]; then

    # set up the model list
    echo "[INFO] Calculating lagged ensemble members for all models: $models"

    for model in $models; do

    # echo the model name
    echo "[INFO] Calculating lagged ensemble members for model: $model"

    # set up the number of ensemble members to extract
    # set up the number of ensemble members to extract
    # first all of the models with 10 runs
    if [ $model == "MPI-ESM1-2-HR" ] || [ $model == "CMCC-CM2-SR5" ] || [ "$model" == "HadGEM3-GC31-MM" ] || [ "$model" == "EC-Earth3" ] || [ "$model" == "MIROC6" ] || [ "$model" == "IPSL-CM6A-LR" ] || [ "$model" == "NorCPM1" ]; then
        run=10
    elif [ $model == "BCC-CSM2-MR" ]; then
        run=8
    elif [ "$model" == "FGOALS-f3-L" ]; then 
        run=9
    elif [ "$model" == "MPI-ESM1-2-LR" ]; then
        run=16
    elif [ "$model" == "CanESM5" ]; then
        run=20
    elif [ "$model" == "CESM1-1-CAM5-CMIP5" ]; then
        run=40
    else
        echo "[ERROR] Model $model not found"
        exit 1
    fi

    # set up the output directory
    OUTPUT_DIR=/work/scratch-nopw/benhutch/$model/$location/lotus-outputs
    # make the output directory
    mkdir -p $OUTPUT_DIR

        # loop through the ensemble members
        for run in $(seq 1 $run); do

            #  if the model is NorCPM1 or EC-Earth3 then we need to use a different init number
            if [ "$model" == "NorCPM1" ] || [ "$model" == "EC-Earth3" ]; then
                
            init=2

                # loop through the initialisations
                for init in $(seq 1 $init); do

                    # echo the init
                    echo "[INFO] Calculating lagged ensemble members for init: $init"

                    # echo the run and init
                    echo "[INFO] Calculating lagged ensemble members for model: $model"
                    echo "[INFO] Calculating lagged ensemble members for location: $location"
                    echo "[INFO] Calculating lagged ensemble members for run: $run"
                    echo "[INFO] Calculating lagged ensemble members for init: $init"

                    # submit the job to LOTUS
                    sbatch --partition=short-serial -t 10 -o $OUTPUT_DIR/${model}-${location}-${run}-${init}.out -e $OUTPUT_DIR/${model}-${location}-${run}-${init}.err $EXTRACTOR $location $model $run $init

                done
            else

            init=1

                # echo the run and init
                echo "[INFO] Calculating lagged ensemble members for model: $model"
                echo "[INFO] Calculating lagged ensemble members for location: $location"
                echo "[INFO] Calculating lagged ensemble members for run: $run"
                echo "[INFO] Calculating lagged ensemble members for init: $init"

                # submit the job to LOTUS
                sbatch --partition=short-serial -t 10 -o $OUTPUT_DIR/${model}-${location}-${run}-${init}.out -e $OUTPUT_DIR/${model}-${location}-${run}-${init}.err $EXTRACTOR $location $model $run $init

            fi
        done
    done

else

# echo the model name
echo "[INFO] Calculating lagged ensemble members for model: $model"

# set the output directory
OUTPUT_DIR=/work/scratch-nopw/benhutch/$model/$location/lotus-outputs
# make the output directory
mkdir -p $OUTPUT_DIR

# set up the number of ensemble members to extract
# first all of the models with 10 runs
if [ $model == "MPI-ESM1-2-HR" ] || [ $model == "CMCC-CM2-SR5" ] || [ "$model" == "HadGEM3-GC31-MM" ] || [ "$model" == "EC-Earth3" ] || [ "$model" == "MIROC6" ] || [ "$model" == "IPSL-CM6A-LR" ] || [ "$model" == "NorCPM1" ]; then
    run=10
elif [ $model == "BCC-CSM2-MR" ]; then
    run=8
elif [ "$model" == "FGOALS-f3-L" ]; then 
    run=9
elif [ "$model" == "MPI-ESM1-2-LR" ]; then
    run=16
elif [ "$model" == "CanESM5" ]; then
    run=20
elif [ "$model" == "CESM1-1-CAM5-CMIP5" ]; then
    run=40
else
    echo "[ERROR] Model $model not found"
    exit 1
fi

# loop through the ensemble members
    # loop through the ensemble members
    for run in $(seq 1 $run); do

        #  if the model is NorCPM1 or EC-Earth3 then we need to use a different init number
        if [ "$model" == "NorCPM1" ] || [ "$model" == "EC-Earth3" ]; then
            
        init=2

            # loop through the initialisations
            for init in $(seq 1 $init); do

                # echo the init
                echo "[INFO] Calculating lagged ensemble members for init: $init"

                # echo the run and init
                echo "[INFO] Calculating lagged ensemble members for model: $model"
                echo "[INFO] Calculating lagged ensemble members for location: $location"
                echo "[INFO] Calculating lagged ensemble members for run: $run"
                echo "[INFO] Calculating lagged ensemble members for init: $init"

                # submit the job to LOTUS
                sbatch --partition=short-serial -t 10 -o $OUTPUT_DIR/${model}-${location}-${run}-${init}.out -e $OUTPUT_DIR/${model}-${location}-${run}-${init}.err $EXTRACTOR $location $model $run $init

            done
        else

        init=1

            # echo the run and init
            echo "[INFO] Calculating lagged ensemble members for model: $model"
            echo "[INFO] Calculating lagged ensemble members for location: $location"
            echo "[INFO] Calculating lagged ensemble members for run: $run"
            echo "[INFO] Calculating lagged ensemble members for init: $init"

            # submit the job to LOTUS
            sbatch --partition=short-serial -t 10 -o $OUTPUT_DIR/${model}-${location}-${run}-${init}.out -e $OUTPUT_DIR/${model}-${location}-${run}-${init}.err $EXTRACTOR $location $model $run $init

        fi
    done
fi

