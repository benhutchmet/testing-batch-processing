#!/bin/bash

# calculate-model-mean-state.bash
#
# Example usage: calculate-model-mean-state.bash iceland BCC-CSM2-MR

USAGE_MESSAGE="Usage: calculate-model-mean-state.bash <location> <model>"

# check the number of command line arguments
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

# set up the files to be processed
# only process the years 2-9 DJFM files
files="/work/scratch-nopw/benhutch/$model/$location/outputs/years-2-9-DJFM-*.nc"

# loop through the files
for file in $files; do

    # echo the file name
    echo "[INFO] Calculating the model mean state for file: $file"
    temp_fname="temp-$(basename "$file")"
    TEMP_FILE="$OUTPUT_DIR/$temp_fname"

    # calculate the time mean for each file
    cdo timmean "$file" "$TEMP_FILE"

done

# calculate the model mean state
# the ensemble mean of all start dates, all
# ensemble members for years 2-9 DJFM means
cdo ensmean "$OUTPUT_DIR/temp-*.nc" "$OUTPUT_DIR/model-mean-state.nc"

# remove the temporary files
# this doesn't work for some reason
# maybe within the next script?
# rm "$OUTPUT_DIR/temp-*.nc"


