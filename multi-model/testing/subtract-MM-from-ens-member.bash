#!/bin/bash

# subtracts the model mean state from each ensemble member for each start date

# Usage: subtract-MM-from-ens-member.bash <location> <model> <year>

USAGE_MESSAGE="Usage: subtract-MM-from-ens-member.bash <location> <model> <year>"

# check the number of command line arguments
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

# set up the files to be processed
# only process the years 2-9 DJFM files
files="/work/scratch-nopw/benhutch/$model/$location/outputs/years-2-9-DJFM-*_s${year}*.nc"

# extract the model mean state
model_mean_state="/work/scratch-nopw/benhutch/$model/$location/outputs/model-mean-state/model-mean-state.nc"


# activate the environment containing CDO
module load jaspy

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
