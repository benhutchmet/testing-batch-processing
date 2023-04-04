#!/bin/bash

# BCC-CSM2-MR.calc-sub-bl.bash
#
# Usage:    BCC-CSM2-MR.calc-sub-bl.bash <location>
#

# extract the location
location=$1

# file will be given by:
# years-2-9-DJFM-iceland-psl_Amon_BCC-CSM2-MR_dcppA-hindcast_s2014-r8i1p1f1_gn_201401-202312.nc
# or
# years-2-9-DJFM-azores-psl_Amon_BCC-CSM2-MR_dcppA-hindcast_s2014-r8i1p1f1_gn_201401-202312.nc

# set the output directory
OUTPUT_DIR=/home/users/benhutch/BCC-CSM2-MR/$location/model-mean-state
# make the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# set the files to be processed
# we only want to extract the files constrained to years 2-9 DJFM
files=/home/users/benhutch/BCC-CSM2-MR/$location/outputs/years-2-9-DJFM-*.nc

# activate the environment containing CDO
module load jaspy

# first we want to calculate the model mean state
# for BCC-CSM2-MR
# for all ensemble members (8)
# for all start dates (1961-2014)
# for hindcast years 2-9 (1962 Dec - 1970 Mar)

# loop through the files and process them
for INPUT_FILE in $files; do

    echo "[INFO] Calculating model mean state: $INPUT_FILE"
    fname=model-mean-state-$(basename $INPUT_FILE)
    temp_fname=temp$(basename $INPUT_FILE)
    OUTPUT_FILE=$OUTPUT_DIR/$fname
    TEMP_FILE=$OUTPUT_DIR/$temp_fname

    # calculate the time mean
    cdo timmean $INPUT_FILE $TEMP_FILE

done

# now take the ensemble mean to calculate the nmodel mean state
cdo ensmean $OUTPUT_DIR/temp*.nc $OUTPUT_DIR/model-mean-state.nc

# remove all of the intermediate files
rm $OUTPUT_DIR/temp*.nc