#!/bin/bash

# submit-all-multi-model.time-mean.ind-ens-members.bash
#
# For example: submit-all-multi-model.time-mean.ind-ens-members.bash azores 1960 1969
#

# import the updated models list
source $PWD/models.bash
echo "[INFO] Models list: $models"

USAGE_MESSAGE="Usage: submit-all-multi-model.time-mean.inc-ens-members.bash <location> <model> <start_year> <end_year>"

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

# set the extractor script
EXTRACTOR=$PWD/multi-model.time-mean.ind-ens-members.bash

# loop through the models
if [ $model == "all" ]; then

    # set up the model list
    echo "[INFO] Calculating time means for all models: $models"

    for model in $models; do

        # echo the model name
        echo "[INFO] Calculating time means for model: $model"

        # set up the number of ensemble members to extract
        if [ "$model" == "BCC-CSM2-MR" ]; then
            run=8
        elif [ "$model" == "MPI-ESM1-2-HR" ]; then
            run=10
        elif [ "$model" == "CanESM5" ]; then
            run=20
        elif [ "$model" == "CMCC-CM2-SR5" ]; then
            run=10
        elif [ "$model" == "HadGEM3-GC31-MM" ]; then
            run=10
        elif [ "$model" == "EC-Earth3" ]; then
            run=10
        elif [ "$model" == "MPI-ESM1-2-LR" ]; then
            run=16
        elif [ "$model" == "FGOALS-f3-L" ]; then
            run=9
        elif [ "$model" == "MIROC6" ]; then
            run=10
        elif [ "$model" == "IPSL-CM6A-LR" ]; then
            run=10
        elif [ "$model" == "CESM1-1-CAM5-CMIP5" ]; then
            run=40
        elif [ "$model" == "NorCPM1" ]; then
            run=10
        else
            echo "[ERROR] Model not recognised"
            exit 1
        fi

        # set the output directory
        OUTPUTS_DIR=/work/scratch-nopw/benhutch/$model/$location/lotus-outputs

        # make the output directory if it doesn't exist
        mkdir -p $OUTPUTS_DIR

        # create an outer loop to loop through the years
        for year in $(seq $start_year $end_year); do

            # echo the year of the run
            echo "[INFO] Calculating time means for year: $year"

            for run in $(seq 1 $run); do


                # if model is HadGEM3 or EC-Earth3, then we need to add the run number to the end of the model name
                if [ "$model" == "HadGEM3-GC31-MM" ] || [ "$model" == "EC-Earth3" ]; then

                    init=2

                    for init in $(seq 1 $init); do

                        # echo the init
                        echo "[INFO] Calculating time means for init: $init"

                        # set the date
                        year=$(printf "%d" $year)
                        echo "[INFO] Submitting job to LOTUS for year: $year"
                        # Submit the job to LOTUS
                        sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/${year}.%j.out \
                            -e $OUTPUTS_DIR/${year}.%j.err $EXTRACTOR $location $model $year $run $init

                    done

                else

                init=1

                year=$(printf "%d" $year)
                echo "[INFO] Submitting job to LOTUS for year: $year"
                # Submit the job to LOTUS
                sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/${year}.%j.out \
                       -e $OUTPUTS_DIR/${year}.%j.err $EXTRACTOR $location $model $year $run $init

                fi

            done

        done

    done

else

# modify this bit with run and init numbers

    # echo the model name
    echo "[INFO] Calculating time means for model: $model"

    # set the output directory
    OUTPUTS_DIR=/work/scratch-nopw/benhutch/$model/$location/lotus-outputs

    # make the output directory if it doesn't exist
    mkdir -p $OUTPUTS_DIR

    # set up the number of ensemble members to extract
    if [ "$model" == "BCC-CSM2-MR" ]; then
        run=8
    elif [ "$model" == "MPI-ESM1-2-HR" ]; then
        run=10
    elif [ "$model" == "CanESM5" ]; then
        run=20
    elif [ "$model" == "CMCC-CM2-SR5" ]; then
        run=10
    elif [ "$model" == "HadGEM3-GC31-MM" ]; then
        run=10
    elif [ "$model" == "EC-Earth3" ]; then
        run=10
    elif [ "$model" == "MPI-ESM1-2-LR" ]; then
        run=16
    elif [ "$model" == "FGOALS-f3-L" ]; then
        run=9
    elif [ "$model" == "MIROC6" ]; then
        run=10
    elif [ "$model" == "IPSL-CM6A-LR" ]; then
        run=10
    elif [ "$model" == "CESM1-1-CAM5-CMIP5" ]; then
        run=40
    elif [ "$model" == "NorCPM1" ]; then
        run=10
    else
        echo "[ERROR] Model not recognised"
        exit 1
    fi

    # create an outer loop to loop through the years
    for year in $(seq $start_year $end_year); do

        for run in $(seq 1 $run); do

            # if model is HadGEM3 or EC-Earth3, then we need to add the run number to the end of the model name
            if [ "$model" == "HadGEM3-GC31-MM" ] || [ "$model" == "EC-Earth3" ]; then

                init=[1-2]

                for init in $init; do

                    # echo the init
                    echo "[INFO] Calculating time means for init: $init"

                    # set the date
                    year=$(printf "%d" $year)
                    echo "[INFO] Submitting job to LOTUS for year: $year"
                    # Submit the job to LOTUS
                    sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/${year}.%j.out \
                        -e $OUTPUTS_DIR/${year}.%j.err $EXTRACTOR $location $model $year $run $init

                done

            else

            init=1

            year=$(printf "%d" $year)
            echo "[INFO] Submitting job to LOTUS for year: $year"
            # Submit the job to LOTUS
            sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/${year}.%j.out \
                    -e $OUTPUTS_DIR/${year}.%j.err $EXTRACTOR $location $model $year $run $init

            fi
        done
    done
fi