#!/bin/bash

# multi-model.combine_anom.bash
#
# Usage: multi-model.combine_anom.bash <location> <model> <year>
#
# For example: multi-model.combine_anom.bash azores BCC-CSM2-MR 1961
#

USAGE_MESSAGE="Usage: multi-model.combine_anom.bash <location> <model> <year>"

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

# activate the environment containing CDO
module load jaspy

# if statement for the EC-earth init case
if [ $model == "EC-Earth3" ]; then

    # echo the model being processed
    echo "[INFO] Model being processed has multiple initialization schemes: $model"

    # set up the initializations
    # two schemes, 1 and 2
    init1=1
    init2=2

    # set the files to be processed depending on the init scheme
    files1="/work/scratch-nopw/benhutch/$model/$location/outputs/subtracted-MM-state-*s${year}-r*i${init1}*.nc"
    files2="/work/scratch-nopw/benhutch/$model/$location/outputs/subtracted-MM-state-*s${year}-r*i${init2}*.nc"

    # echo the files being processed
    echo "[INFO] Files being processed, group 1: $files1"
    echo "[INFO] Files being processed, group 2: $files2"

    # set up the ensemble mean file name
    ensemble_mean_fname="ensemble-mean-years-2-9-DJFM-anomalies-${location}-psl_Amon_${model}_dcppA-hindcast_s${year}.nc"
    # set up the ensemble mean file path
    ensemble_mean_file="$OUTPUT_DIR/$ensemble_mean_fname"

    # calculate the ensemble mean
    # taking the ensemble mean for each init scheme separately
    # then taking the ensemble mean of the two init scheme ensemble means
    cdo ensmean -ensmean $files1 -ensmean $files2 $ensemble_mean_file

else

    # echo the model being processed
    echo "[INFO] Model being processed: $model"

    # set the files to be processed
    files="/work/scratch-nopw/benhutch/$model/$location/outputs/subtracted-MM-state-*_s${year}*.nc"

    # echo the files being processed
    echo "[INFO] Files being processed: $files"

    # activate the environment containing CDO
    module load jaspy

    # set up the ensemble mean file name
    ensemble_mean_fname="ensemble-mean-years-2-9-DJFM-anomalies-${location}-psl_Amon_${model}_dcppA-hindcast_s${year}.nc"

    # set up the ensemble mean file path
    ensemble_mean_file="$OUTPUT_DIR/$ensemble_mean_fname"

    # calculate the ensemble mean
    cdo ensmean $files $ensemble_mean_file

fi