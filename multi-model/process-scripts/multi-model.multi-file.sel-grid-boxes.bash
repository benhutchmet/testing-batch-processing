#!/bin/bash

# multi-model.multi-file.sel-grid-boxes.bash
#
# Test script to check whether the data in scratch is usable
# As some years and some ensemble members produce spurious HDF errors
#
# Usage: multi-model.multi-file.sel-grid-boxes.bash <location> <model> <year> <run>
#
# For example: multi-model.multi-file.sel-grid-boxes.bash azores HadGEM3-GC31-MM 1960 1
#

# import the models list
source $PWD/models.bash
# echo the multi-models list
echo "[INFO] Multi-models list: $multi_file_models"

# set the usage message
USAGE_MESSAGE="Usage: sel-grid-box-HadGEM-EC-Earth.test.bash <location> <model> <year> <run>"

# check that the correct number of arguments have been passed
if [ $# -ne 4 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# extract the location
location=$1

# extract the model, initial year and final year]
model=$2
year=$3

# set the ensemble member
run=$4

# set up an if loop for the location gridbox selection
if [ $location == "azores" ]; then
    lon1=-28
    lon2=-20
    lat1=36
    lat2=40
elif [ $location == "iceland" ]; then
    lon1=-25
    lon2=-16
    lat1=63
    lat2=70
else
    echo "[ERROR] Location not recognised"
    exit 1
fi

# set up an if loop for the model name
if [ $model == "HadGEM3-GC31-MM" ]; then
    model_group="MOHC"
elif [ $model == "EC-Earth3" ]; then
    model_group="EC-Earth-Consortium"
else
    echo "[ERROR] Model not recognised"
    exit 1
fi

# echo the model name and group
echo "[INFO] Model: $model"
echo "[INFO] Model group: $model_group"

# set the output directory
OUTPUT_DIR=/work/scratch-nopw/benhutch/$model/$location/outputs
# make the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# set the files to be processed
files=/work/scratch-nopw/benhutch/$model/outputs/mergetime/*s${year}-r${run}i*.nc

# activate the environment containing CDO
module load jaspy

# loop through the files and process them
for INPUT_FILE in $files; do

    echo "[INFO] Processing file: $INPUT_FILE"
    fname=${location}-$(basename $INPUT_FILE)
    OUTPUT_FILE=$OUTPUT_DIR/$fname
    # select the lat lon box
    cdo sellonlatbox,$lon1,$lon2,$lat1,$lat2 $INPUT_FILE $OUTPUT_FILE

done