#!/bin/bash

# multi-model.sub_MM.bash
#
# For example: multi-model.sub_MM.bash azores BCC-CSM2-MR 1980
#

USAGE_MESSAGE="Usage: multi-model.sub_MM.bash <location> <model> <year>"

# check that the correct number of arguments have been passed
if [ $# -ne 3 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# extract the location, model and year
location=$1
model=$2
year=$3

# set the output directory
OUTPUT_DIR=/work/scratch-nopw/benhutch/$model/$location/outputs
# make the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# set the files to be processed
# if else for models with multiple init schems
if [ $model == "EC-Earth3" ] || [ $model == "NorCPM1" ]; then
    # set the files to be processed
    files_i1="/work/scratch-nopw/benhutch/$model/$location/outputs/years-2-9-DJFM-*_s${year}*i1*.nc"
    files_i2="/work/scratch-nopw/benhutch/$model/$location/outputs/years-2-9-DJFM-*_s${year}*i2*.nc"
else
    files="/work/scratch-nopw/benhutch/$model/$location/outputs/years-2-9-DJFM-*_s${year}*.nc"
fi


# extract the model mean state
if [ $model == "EC-Earth3" ] || [ $model == "NorCPM1" ]; then
    # extract the model mean states for i1 and i2 separately
    model_mean_state_i1="/work/scratch-nopw/benhutch/$model/$location/outputs/model-mean-state/model-mean-state-i1.nc"
    model_mean_state_i2="/work/scratch-nopw/benhutch/$model/$location/outputs/model-mean-state/model-mean-state-i2.nc"
else
    model_mean_state="/work/scratch-nopw/benhutch/$model/$location/outputs/model-mean-state/model-mean-state.nc"
fi

# activate the environment containing CDO
module load jaspy

if [ $model == "EC-Earth3" ] || [ $model == "NorCPM1" ]; then

# echo the model name
echo "[INFO] Subtracting the model mean state for model: $model"
echo "[INFO] i1 and i2 schemes are going to have model mean states subtracted separately"

    # first loop over the i1 files
    for file in $files_i1; do

        # echo that we are subtracting the model mean state for initialization scheme i1
        echo "[INFO] Subtracting the model mean state for initialization scheme i1"
        
        # echo the file name
        echo "[INFO] Subtracting the model mean state from file: $file"
        fname="subtracted-MM-state-$(basename "$file")"
        OUTPUT_FILE="$OUTPUT_DIR/$fname"

        # use grep and cut to extract the number 7 from the file path
        ensemble_member=$(echo $file | grep -o 'r[0-9]*' | cut -c2-)
        # use grep and sed to extract the initialization year from the file path
        init_year=$(echo $file | grep -o 's[0-9]*' | sed 's/s//')

        # print the extracted ensemble member
        echo "[INFO] subtracting model mean state for ensemble member: $ensemble_member"

        # print the extracted initialization year
        echo "[INFO] subtracting model mean state for initialization year: $init_year"

        # subtract the model mean state
        cdo sub $file $model_mean_state_i1 $OUTPUT_FILE

        # print the output file for debugging
        echo "[INFO] output file: $OUTPUT_FILE"

    done

    # second loop over the i2 files
    for file in $files_i2; do

        # echo that we are subtracting the model mean state for initialization scheme i2
        echo "[INFO] Subtracting the model mean state for initialization scheme i2"
        
        # echo the file name
        echo "[INFO] Subtracting the model mean state from file: $file"
        fname="subtracted-MM-state-$(basename "$file")"
        OUTPUT_FILE="$OUTPUT_DIR/$fname"

        # use grep and cut to extract the number 7 from the file path
        ensemble_member=$(echo $file | grep -o 'r[0-9]*' | cut -c2-)
        # use grep and sed to extract the initialization year from the file path
        init_year=$(echo $file | grep -o 's[0-9]*' | sed 's/s//')

        # print the extracted ensemble member
        echo "[INFO] subtracting model mean state for ensemble member: $ensemble_member"

        # print the extracted initialization year
        echo "[INFO] subtracting model mean state for initialization year: $init_year"

        # subtract the model mean state
        cdo sub $file $model_mean_state_i2 $OUTPUT_FILE

        # print the output file for debugging
        echo "[INFO] output file: $OUTPUT_FILE"

    done

else
    # set up the for loop
    for file in $files; do

        # echo the file name
        echo "[INFO] Subtracting the model mean state from file: $file"
        fname="subtracted-MM-state-$(basename "$file")"
        OUTPUT_FILE="$OUTPUT_DIR/$fname"

        # use grep and cut to extract the number 7 from the file path
        ensemble_member=$(echo $file | grep -o 'r[0-9]*' | cut -c2-)
        # use grep and sed to extract the initialization year from the file path
        init_year=$(echo $file | grep -o 's[0-9]*' | sed 's/s//')

        # print the extracted ensemble member
        echo "[INFO] subtracting model mean state for ensemble member: $ensemble_member"

        # print the extracted initialization year
        echo "[INFO] subtracting model mean state for initialization year: $init_year"

        # subtract the model mean state
        cdo sub $file $model_mean_state $OUTPUT_FILE

        # print the output file for debugging
        echo "[INFO] output file: $OUTPUT_FILE"

    done
fi
