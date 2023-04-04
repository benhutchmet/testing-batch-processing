#!/bin/bash

# BCC-CSM2-MR.year-2-9.test.bash
#
# Usage:    BCC-CSM2-MR.year-2-9.test.bash <location>
# constrains data to the years 2-9 DJFM

# extract the location
location=$1

# set the output directory
OUTPUT_DIR=/home/users/benhutch/BCC-CSM2-MR/$location/outputs
# make the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# set the files to be processed
files=/home/users/benhutch/BCC-CSM2-MR/$location/outputs/*.nc

# activate the environment containing CDO
module load jaspy

# loop through the files and process them
for INPUT_FILE in $files; do

    echo "[INFO] Creating years 2-9 DJFM files: $INPUT_FILE"
    fname=years-2-9-DJFM-$(basename $INPUT_FILE)
    temp_fname=temp-$(basename $INPUT_FILE)
    OUTPUT_FILE=$OUTPUT_DIR/$fname
    TEMP_FILE=$OUTPUT_DIR/$temp_fname

    # extract the initialization year "1960" from the input file:
    # /home/users/benhutch/BCC-CSM2-MR/azores/outputs/azores-psl_Amon_BCC-CSM2-MR_dcppA-hindcast_s1961-r1i1p1f1_gn_196101-197012.nc
    path=$INPUT_FILE
    # Extract the filename from the path
    filename=$(basename "$path")
    # Extract the initialization year from the filename
    year=$(echo "$filename" | sed 's/.*_s\([0-9]\{4\}\)-.*/\1/')
    echo "Initialization year is: $year"

    # set the start and end dates
    # year + 1
    # and year + 9
    start_year=$(( $year + 1 ))
    end_year=$(( $year + 9 ))

    echo "Year 2 winter start is: $start_year-12-01"
    echo "Year 9 winter end is: $end_year-03-31"

    # constrain to season DJFM
    cdo select,season=DJFM $INPUT_FILE $TEMP_FILE

    # extract the 2-9 years using cdo
    cdo select,startdate=$start_year-12-01,enddate=$end_year-03-31 $TEMP_FILE $OUTPUT_FILE

    # remove the temporary file
    rm $TEMP_FILE

done

