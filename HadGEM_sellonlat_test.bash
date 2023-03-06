#!/bin/bash

# HadGEM_sellonlat_test.bash
#
# Usage:    HadGEM_sellonlat_test.bash <lon1> <lon2> <lat1> <lat2> <location>

# get the lon/lat values from the command line
lon1=$1
lon2=$2
lat1=$3
lat2=$4

# get the location from the command line
location=$5

# set the output directory
OUTPUT_DIR=/home/users/benhutch/batch-testing/$location/outputs
# make the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# set the files to be processed
# specifies the files to be processed as all of the years and all of the ensemble runs (10) from 1960-2018
files = /badc/cmip6/data/CMIP6/DCPP/MOHC/HadGEM3-GC31-MM/dcppA-hindcast/s*-r*i1p1f2/Amon/psl/gn/files/d20200417/*.nc

# activate the environment containing CDO
module load jaspy

# loop through the files and process them
for INPUT_FILE in $files; do

    echo "[INFO] Subsetting: $INPUT_FILE"
    fname=${location}-$(basename $INPUT_FILE)
    OUTPUT_FILE=$OUTPUT_DIR/$fname
    cdo sellonlatbox,$lon1,$lon2,$lat1,$lat2 $INPUT_FILE $OUTPUT_FILE

done
