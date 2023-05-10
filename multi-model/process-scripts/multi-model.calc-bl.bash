#!/bin/bash

# multi-model.calc-bl.bash
#
# For example: multi-model.calc-bl.bash azores BCC-CSM2-MR
#

USAGE_MESSAGE="Usage: multi-model.calc-bl.bash <location> <model>"

# check that the correct number of arguments have been passed
if [ $# -ne 2 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# extract the location and model
location=$1
model=$2

# set the output directory
OUTPUT_DIR=/work/scratch-nopw/benhutch/$model/$location/outputs/model-mean-state
# make the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# set the files to be processed
# we only want to extract the files constrained to years 2-9 DJFM
# if the model is EC-Earth3 or NorCPM1
# then we need to calculate the means for each of the init schemes
# otherwise the files are just the ensemble members
if [ $model == "EC-Earth3" ] || [ $model == "NorCPM1" ]; then
    # set the files to be processed
    i1_files="/work/scratch-nopw/benhutch/$model/$location/outputs/years-2-9-DJFM-*i1*.nc"
    i2_files="/work/scratch-nopw/benhutch/$model/$location/outputs/years-2-9-DJFM-*i2*.nc"
else
    files="/work/scratch-nopw/benhutch/$model/$location/outputs/years-2-9-DJFM-*.nc"
fi

# activate the environment containing CDO
module load jaspy

# loop through the files and process them
# if the model is EC-Earth3 or NorCPM1
# calculate the means for each of the init schemes separately
# otherwise just calculate the ensemble mean
if [ $model == "EC-Earth3" ] || [ $model == "NorCPM1" ]; then

# echo the model name
echo "[INFO] Calculating the model mean state for model: $model"

    # first loop over the i1 files
    for file in $i1_files; do

        echo "[INFO] Calculating the model mean state for init scheme: i1"

        # echo the file name
        echo "[INFO] Calculating the model mean state for file: $file"
        temp_fname="temp-$(basename "$file")"
        TEMP_FILE="$OUTPUT_DIR/$temp_fname"

        # calculate the time mean for each file
        cdo timmean "$file" "$TEMP_FILE"

    done

    # now take the ensemble mean to calculate the nmodel mean state
    # for the i1 files
    cdo ensmean $OUTPUT_DIR/temp-*i1*.nc $OUTPUT_DIR/model-mean-state-i1.nc

    # now loop over the i2 files
    for file in $i2_files; do

        echo "[INFO] Calculating the model mean state for init scheme: i2"

        # echo the file name
        echo "[INFO] Calculating the model mean state for file: $file"
        temp_fname="temp-$(basename "$file")"
        TEMP_FILE="$OUTPUT_DIR/$temp_fname"

        # calculate the time mean for each file
        cdo timmean "$file" "$TEMP_FILE"

    done

    # now take the ensemble mean to calculate the nmodel mean state
    # for the i2 files
    cdo ensmean $OUTPUT_DIR/temp-*i2*.nc $OUTPUT_DIR/model-mean-state-i2.nc

else


    for file in $files; do

        # echo the file name
        echo "[INFO] Calculating the model mean state for file: $file"
        temp_fname="temp-$(basename "$file")"
        TEMP_FILE="$OUTPUT_DIR/$temp_fname"

        # calculate the time mean for each file
        cdo timmean "$file" "$TEMP_FILE"

    done

    # now take the ensemble mean to calculate the nmodel mean state
    cdo ensmean $OUTPUT_DIR/temp-*.nc $OUTPUT_DIR/model-mean-state.nc

fi