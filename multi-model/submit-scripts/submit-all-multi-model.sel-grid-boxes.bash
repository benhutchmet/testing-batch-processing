#!/bin/bash

# submit-all-multi-model.bash
#
# Usage: submit-all-multi-model.bash <location> <start_year> <finish_year> <model>
#
# For example: submit-all-multi-model.bash azores 1960 1969 BCC-CSM2-MR
#
# set the partition/account arguments for LOTUS based on usage context
# SBATCH --partition=short-serial

# import the models list
source $PWD/models.bash
# echo the models list
echo "[INFO] Models list: $models"

# set the usage message
USAGE_MESSAGE="Usage: submit-all-multi-model.bash <location> <start_year> <finish_year> <model>"

# check that the correct number of arguments have been passed
if [ $# -ne 4 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# extract the location
location=$1

# extract the start and finish years
start_year=$2
finish_year=$3

# extract the model name
model=$4

# if model=all, then run a for loop over all the models
if [ $model == "all" ]; then

    # set up the model list
    echo "[INFO] Extracting data for all models: $models"

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
        elif [ $model == "HadGEM3-GC31-MM" ]; then
            run=10
        elif [ $model == "EC-Earth3" ]; then
            run=10
        elif [ $model == "EC-Earth3-HR" ]; then
            run=10
        elif [ $model == "MRI-ESM2-0" ]; then
            run=10
        elif [ $model == "MPI-ESM1-2-HR" ]; then
            run=16
        elif [ $model == "FGOALS-f3-L" ]; then
            run=9
        elif [ $model == "CNRM-ESM2-1" ]; then
            run=10
        elif [ $model == "MIROC6" ]; then
            run=10
        elif [ $model == "IPSL-CM6A-LR" ]; then
            run=10
        elif [ $model == "CESM1-1-CAM5-CMIP5" ]; then
            run=40
        elif [ $model == "NorCPM1" ]; then
            run=10
        else
            echo "[ERROR] Model not recognised"
            exit 1
        fi
        
        # echo the number of ensemble members
        echo "[INFO] Number of ensemble members: $run"

        # depending on the model set the extractor script
        if [[ $model == "BCC-CSM2-MR" || $model == "MPI-ESM1-2-HR" || $model == "CanESM5" || $model == "CMCC-CM2-SR5" || $model == "MRI-ESM2-0" || $model == "MPI-ESM1-2-HR" || $model == "FGOALS-f3-L" || $model == "CNRM-ESM2-1" || $model == "MIROC6" || $model == "IPSL-CM6A-LR" || $model == "CESM1-1-CAM5-CMIP5" || $model == "NorCPM1" ]]; then
            EXTRACTOR=$PWD/multi-model.sel-grid-boxes.bash
        elif [[ $model == "HadGEM3-GC31-MM" || $model == "EC-Earth3" || $model == "EC-Earth3-HR" ]]; then
            EXTRACTOR=$PWD/multi-model.multi-file.sel-grid-boxes.bash
        else
            echo "[ERROR] Model not recognised"
            exit 1
        fi

        echo "The selected extractor for $model is $EXTRACTOR."


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
        # set up the number of ensemble members to extract
        if [ $model == "BCC-CSM2-MR" ]; then
            run=8
        elif [ $model == "MPI-ESM1-2-HR" ]; then
            run=10
        elif [ $model == "CanESM5" ]; then
            run=20
        elif [ $model == "CMCC-CM2-SR5" ]; then
            run=10
        elif [ $model == "HadGEM3-GC31-MM" ]; then
            run=10
        elif [ $model == "EC-Earth3" ]; then
            run=10
        elif [ $model == "EC-Earth3-HR" ]; then
            run=10
        elif [ $model == "MRI-ESM2-0" ]; then
            run=10
        elif [ $model == "MPI-ESM1-2-HR" ]; then
            run=16
        elif [ $model == "FGOALS-f3-L" ]; then
            run=9
        elif [ $model == "CNRM-ESM2-1" ]; then
            run=10
        elif [ $model == "MIROC6" ]; then
            run=10
        elif [ $model == "IPSL-CM6A-LR" ]; then
            run=10
        elif [ $model == "CESM1-1-CAM5-CMIP5" ]; then
            run=40
        elif [ $model == "NorCPM1" ]; then
            run=10
        else
            echo "[ERROR] Model not recognised"
            exit 1
        fi

        # echo the number of ensemble members
        echo "[INFO] Number of ensemble members: $run"

        # depending on the model set the extractor script
        if [[ $model == "BCC-CSM2-MR" || $model == "MPI-ESM1-2-HR" || $model == "CanESM5" || $model == "CMCC-CM2-SR5" ]]; then
        EXTRACTOR=$PWD/multi-model.sel-grid-boxes.bash
        # else if multi-file model
        # use the multi-model.multi-file.sel-grid-boxes.bash script
        elif [[ $model == "HadGEM3-GC31-MM" || $model == "EC-Earth3" ]]; then
            EXTRACTOR=$PWD/multi-model.multi-file.sel-grid-boxes.bash
        else
            echo "[ERROR] Model not recognised"
            exit 1
        fi

echo "The selected extractor for $model is $EXTRACTOR."
        
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








