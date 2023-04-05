#!/bin/bash

# BCC-CSM2-MR.sel-grid-boxes.bash

# Usage:    BCC-CSM2-MR.sel-grid-boxes.bash <finish year> <Run> <lon1> <lon2> <lat1> <lat2> <location>

# get the start and finish years from the command line
year=$1
run=$2

# get the lon/lat values from the command line
lon1=$3
lon2=$4
lat1=$5
lat2=$6

# get the location from the command line
location=$7

# set the output directory
OUTPUT_DIR=/home/users/benhutch/BCC-CSM2-MR/$location/outputs
# make the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# set the files to be processed
files=/badc/cmip6/data/CMIP6/DCPP/BCC/BCC-CSM2-MR/dcppA-hindcast/s${year}-r${run}i1p1f1/Amon/psl/gn/files/d????????/*.nc

# /badc/cmip6/data/CMIP6/DCPP/BCC/BCC-CSM2-MR/dcppA-hindcast/s1964-r3i1p1f1/Amon/psl/gn/files/d20191213

# activate the environment containing CDO
module load jaspy

# loop through the files and process them
for INPUT_FILE in $files; do

    echo "[INFO] Subsetting: $INPUT_FILE"
    fname=${location}-$(basename $INPUT_FILE)
    OUTPUT_FILE=$OUTPUT_DIR/$fname
    cdo sellonlatbox,$lon1,$lon2,$lat1,$lat2 $INPUT_FILE $OUTPUT_FILE

done

