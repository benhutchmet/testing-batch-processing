#!/bin/bash

# submit-all-multi-model.NAO-anom.ind-ens-members.bash
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
EXTRACTOR=$PWD/multi-model.NAO-anom.ind-ens-members.bash

# run the extractor for each model specified
if [ $model == "all" ]; then

    # echo the models list
    echo "[INFO] Calculating NAO anomalies for all models: $models"

    for model in $models; do

        # echo the model name
        echo "[INFO] Calculating NAO anomalies for model: $model"

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
        OUTPUTS_DIR=/work/scratch-nopw/benhutch/$model/lotus-output/
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
                    echo "[INFO] Submitting job to LOTUS to calculate the NAO anomalies for $model, run $run, init $init"

                    # Submit the job to LOTUS
                    sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/NAO-anomaly.$model.$run.$init.%j.out \
                        -e $OUTPUTS_DIR/NAO-anomaly.$model.$run.$init.%j.err $EXTRACTOR $model $run $init

                done

            else

            # init will only have value 1
            init=1

            # we only have to submit one job to lotus
            echo "[INFO] Submitting job to LOTUS to calculate the NAO anomalies for $model, run $run, init $init"

            # Submit the job to LOTUS
            sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/NAO-anomaly.$model.$run.$init.%j.out \
                -e $OUTPUTS_DIR/NAO-anomaly.$model.$run.$init.%j.err $EXTRACTOR $model $run $init

            fi
        done
    done
else

    # echo the model name
    echo "[INFO] Calculating NAO anomalies for model: $model"

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
    OUTPUTS_DIR=/work/scratch-nopw/benhutch/$model/lotus-output/
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
                echo "[INFO] Submitting job to LOTUS to calculate the NAO anomalies for $model, run $run, init $init"

                # Submit the job to LOTUS
                sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/NAO-anomaly.$model.$run.$init.%j.out \
                    -e $OUTPUTS_DIR/NAO-anomaly.$model.$run.$init.%j.err $EXTRACTOR $model $run $init

            done

        else

        # init will only have value 1
        init=1

        # we only have to submit one job to lotus
        echo "[INFO] Submitting job to LOTUS to calculate the NAO anomalies for $model, run $run, init $init"

        # Submit the job to LOTUS
        sbatch --partition=short-serial -t 5 -o $OUTPUTS_DIR/NAO-anomaly.$model.$run.$init.%j.out \
            -e $OUTPUTS_DIR/NAO-anomaly.$model.$run.$init.%j.err $EXTRACTOR $model $run $init

        fi
    done
fi