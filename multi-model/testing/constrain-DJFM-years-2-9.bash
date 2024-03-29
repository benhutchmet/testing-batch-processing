#!/bin/bash

# constrain-DJFM-years-2-9.bash
#
# Usage:    constrain-DJFM-years-2-9.bash <location> <model>
#
# for example: constrain-DJFM-years-2-9.bash azores BCC-CSM2-MR

# extract the location
location=$1

# extract the model
model=$2

# set the output directory
OUTPUT_DIR=/work/scratch-nopw/benhutch/$model/$location/outputs
# make the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# set the files to be processed
files=/work/scratch-nopw/benhutch/$model/$location/outputs/*.nc

# activate the environment containing CDO
module load jaspy

# loop through the files and process them
for INPUT_FILE in $files; do

    # if file contains years-2-9-DJFM then skip
    if [[ $(basename $INPUT_FILE) == *"years-2-9-DJFM"* ]]; then
        echo "[INFO] Skipping file: $INPUT_FILE"
        continue
    fi

    echo "[INFO] Creating years 2-9 DJFM files: $INPUT_FILE"
    fname=years-2-9-DJFM-$(basename $INPUT_FILE)
    temp_fname=temp-$(basename $INPUT_FILE)
    OUTPUT_FILE=$OUTPUT_DIR/$fname
    TEMP_FILE=$OUTPUT_DIR/$temp_fname

    # extract the initialization year "1960" from the input file
    filename=$(basename "$INPUT_FILE")
    # Extract the initialization year from the filename
    year=$(echo "$filename" | sed 's/.*_s\([0-9]\{4\}\)-.*/\1/')
    echo "Initialization year is: $year"

    # set the start and end dates
    # year + 1
    # and year + 9
    start_year=$(( $year + 1 )) # start of year 2 winter
    end_year=$(( $year + 9 )) # end of year 9 winter

    echo "Year 2 winter start is: $start_year-12-01"
    echo "Year 9 winter end is: $end_year-03-31"

    # constrain to season DJFM
    cdo select,season=DJFM $INPUT_FILE $TEMP_FILE

    # extract the 2-9 years using cdo
    cdo select,startdate=$start_year-12-01,enddate=$end_year-03-31 $TEMP_FILE $OUTPUT_FILE

    # remove the temporary file
    rm $TEMP_FILE

done

