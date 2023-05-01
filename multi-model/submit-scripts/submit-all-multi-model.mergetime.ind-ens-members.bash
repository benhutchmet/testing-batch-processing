#!/bin/bash

# submit-all-multi-model.mergetime.ind-ens-members.bash
#
# Usage: submit-all-multi-model.mergetime.ind-ens-members.bash <location> <model> <run> <init>
#

# import the models list
source $PWD/models.bash
# echo the models list
echo "[INFO] Models list: $models"

USAGE_MESSAGE="Usage: submit-all-multi-model.mergetime.bash <location> <model> <run> <init>"

# check that the correct number of arguments have been passed
if [ $# -ne 4 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# extract the location and model from the command line arguments
location=$1
model=$2

# set the extractor script and the output directory
EXTRACTOR=$PWD/multi-model.mergetime.ind-ens-members.bash

# make sure that cdo is loaded
module load jaspy

# loop through the models
if [ $model == "all" ]; then

    # set up the model list
    echo "[INFO] Merging the time dimension for model: $model"

    for model in $models; do

        # echo the model name
        echo "[INFO] Merging the time dimension for model: $model"

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

        # set the output directory
        OUTPUTS_DIR=/work/scratch-nopw/benhutch/$model/$location/lotus-outputs
        # make the output directory if it doesn't exist
        mkdir -p $OUTPUTS_DIR

        for run in $(seq 1 $run); do

            # if model is HadGEM3 or EC-Earth3
            # need to submit 2 jobs for each run
            if [ "$model" == "HadGEM3-GC31-MM" ] || [ "$model" == "EC-Earth3" ]; then

                # init has values 1 and 2
                init=2

                for init in $(seq 1 $init); do
                    
                # we only have to submit one job to lotus
                echo "[INFO] Submitting job to LOTUS to merge the time dimension for $model, run $run, init $init"

                    # Submit the job to LOTUS
                    sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/merge-time-dimension.%j.out \
                           -e $OUTPUTS_DIR/merge-time-dimension.%j.err $EXTRACTOR $location $model $run $init

                done

            else

                init=1

                # Submit the job to LOTUS
                sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/merge-time-dimension.%j.out \
                       -e $OUTPUTS_DIR/merge-time-dimension.%j.err $EXTRACTOR $location $model $run $init
            fi
        done
    done
else

       # set the output directory
       OUTPUTS_DIR=/work/scratch-nopw/benhutch/$model/$location/lotus-outputs
       # make the output directory if it doesn't exist
       mkdir -p $OUTPUTS_DIR

       # we only have to submit one job to lotus
       echo "[INFO] Submitting job to LOTUS to merge the time dimension for $model"

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

    for run in $(seq 1 $run); do

        # if model is HadGEM3 or EC-Earth3
        # need to submit 2 jobs for each run
        if [ "$model" == "HadGEM3-GC31-MM" ] || [ "$model" == "EC-Earth3" ]; then

            # init has values 1 and 2
            init=2

            for init in $(seq 1 $init); do

            # we only have to submit one job to lotus
            echo "[INFO] Submitting job to LOTUS to merge the time dimension for $model, run $run, init $init"

            # Submit the job to LOTUS
            sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/merge-time-dimension.%j.out \
                    -e $OUTPUTS_DIR/merge-time-dimension.%j.err $EXTRACTOR $location $model $run $init

            done
        else

            init=1

            # we only have to submit one job to lotus
            echo "[INFO] Submitting job to LOTUS to merge the time dimension for $model, run $run, init $init"

            # Submit the job to LOTUS
            sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/merge-time-dimension.%j.out \
                    -e $OUTPUTS_DIR/merge-time-dimension.%j.err $EXTRACTOR $location $model $run $init

        fi
    done
fi