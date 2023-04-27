#!/bin/bash

# lagged-ensemble.bash
#
# For example: lagged-ensemble.bash azores BCC-CSM2-MR 1961
#

USAGE_MESSAGE="Usage: lagged-ensemble.bash <location> <model> <year>"

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
OUTPUT_DIR=/work/scratch-nopw/benhutch/$model/$location/outputs/lagged-ensemble
# make the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# set the files to be processed
files=/work/scratch-nopw/benhutch/$model/$location/outputs/time-mean/time-mean-years-2-9-DJFM-anomalies*s${year}*.nc

# echo the files being processed
echo $files

# activate the environment containing the tools needed
module load jaspy

# Define the range of years to create the lagged ensemble
lag_years=(0 1 2 3)

# Loop through the lag_years array
for lag in ${lag_years[@]}; do
    # Define the lagged year
    lagged_year=$((year - lag))

    # set up the lagged ensemble file name
    lagged_ensemble_fname="lagged-ensemble-${lag}-years-2-9-DJFM-anomalies-${location}-psl_Amon_${model}_dcppA-hindcast_s${lagged_year}.nc"
    # set up the lagged ensemble file path
    lagged_ensemble_file="$OUTPUT_DIR/$lagged_ensemble_fname"

    # Combine the files from the previous years to create the lagged ensemble
    # (You may need to use a tool like CDO, NCO or a custom script to perform this step)

done
