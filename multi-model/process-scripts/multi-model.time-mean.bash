#!/bin/bash

# multi-model.time-mean.bash
#
# For example: multi-model.time-mean.bash azores BCC-CSM2-MR 1961
#

USAGE_MESSAGE="Usage: multi-model.time-mean.bash <location> <model> <year>"

# check that the correct number of arguments have been passed
if [ $# -ne 3 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# extract the location, model and year
location=$1
model=$2
year=$3

# set the output directory
OUTPUT_DIR=/work/scratch-nopw/benhutch/$model/$location/outputs/ensemble-mean
# make the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# set the files to be processed
files=/work/scratch-nopw/benhutch/$model/$location/outputs/ensemble-mean/ensemble-mean-years-2-9-DJFM-anomalies*s${year}*.nc

# echo the files being processed
echo $files

# activate the environment containing CDO
module load jaspy

# set up the time mean file name
time_mean_fname="time-mean-years-2-9-DJFM-anomalies-${location}-psl_Amon_${model}_dcppA-hindcast_s${year}.nc"
# set up the time mean file path
time_mean_file="$OUTPUT_DIR/$time_mean_fname"

# calculate the time mean
cdo timmean $files $time_mean_file