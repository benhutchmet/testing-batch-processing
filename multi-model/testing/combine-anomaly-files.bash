#!/bin/bash

# combine_anomaly_files.bash
#
# For example: combine_anomaly_files.bash azores BCC-CSM2-MR 1961
#

USAGE_MESSAGE="Usage: combine_anomaly_files.bash <location> <model> <year>"

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
files="/work/scratch-nopw/benhutch/$model/$location/outputs/subtracted-MM-state-*_s${year}*.nc"

# activate the environment containing CDO
module load jaspy

# set up the ensemble mean file name
ensemble_mean_fname="ensemble-mean-years-2-9-DJFM-anomalies-${location}-psl_Amon_${model}_dcppA-hindcast_s${year}.nc"

# set up the ensemble mean file path
ensemble_mean_file="$OUTPUT_DIR/$ensemble_mean_fname"

# calculate the ensemble mean
cdo ensmean $files $ensemble_mean_file