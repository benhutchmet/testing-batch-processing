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
OUTPUT_DIR=/home/users/benhutch/$model/$location/outputs/model-mean-state
# make the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# set the files to be processed
# we only want to extract the files constrained to years 2-9 DJFM
files="/work/scratch-nopw/benhutch/$model/$location/outputs/years-2-9-DJFM-*.nc"

# activate the environment containing CDO
module load jaspy

# loop through the files and process them
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

# remove all of the intermediate files
# in next step
# rm $OUTPUT_DIR/temp*.nc