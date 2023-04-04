#!/bin/bash

# mergetime_test.bash
#
# Usage: mergetime_test.bash <location>
#

# set the location
location=$1

# set the output directory
OUTPUT_DIR=/home/users/benhutch/BCC-CSM2-MR/$location/mergetime
# make the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# set the files to be processed
files=/home/users/benhutch/BCC-CSM2-MR/$location/time-mean/time-mean-????.nc

# echo the files to be processed
echo "[INFO] files to be processed: $files"

# activate the environment containing CDO
module load jaspy

# set the file name for the merged file
fname_merged=merged_dataset_BCC-CSM2-MR_1961-2014-${location}.nc

# merge the files
cdo mergetime $files $OUTPUT_DIR/$fname_merged
