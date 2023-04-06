#!/bin/bash

# multi-model.mergetime.bash
#
# For example: multi-model.mergetime.bash azores BCC-CSM2-MR
#

USAGE_MESSAGE="Usage: multi-model.mergetime.bash <location> <model>"

# check that the correct number of arguments have been passed
if [ $# -ne 2 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# set the location and model
location=$1
model=$2

# set the output directory
OUTPUT_DIR=/work/scratch-nopw/benhutch/$model/$location/outputs/mergetime
# make the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# set the files to be processed
files=/work/scratch-nopw/benhutch/$model/$location/outputs/ensemble-mean/time-mean-years-2-9-DJFM-anomalies*.nc

# echo the files being processed
echo $files

# activate the environment containing CDO
module load jaspy

# set up the filename for the merged file
merged_fname="merged-time-mean-years-2-9-DJFM-anomalies-${location}-psl_Amon_dcppA-hindcast-${model}.nc"
# set up the path for the merged file
merged_file="$OUTPUT_DIR/$merged_fname"

# merge the files
cdo mergetime $files $merged_file