#!/bin/bash

# multi-model.multi-file.sel-grid-boxes.bash
#
# Test script to check whether the data in scratch is usable
# As some years and some ensemble members produce spurious HDF errors
#
# Usage: multi-model.multi-file.sel-grid-boxes.bash <year> <run> <location> <model>
#
# For example: multi-model.multi-file.sel-grid-boxes.bash 1960 1 azores HadGEM3-GC31-MM
#

# import the models list
source $PWD/models.bash
# echo the multi-models list
echo "[INFO] Multi-models list: $multi_file_models"

# set the usage message
USAGE_MESSAGE="Usage: multi-model.multi-file.sel-grid-boxes.bash <year> <run> <location> <model>"

# check that the correct number of arguments have been passed
if [ $# -ne 4 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# extract the args from the command line
year=$1
run=$2
location=$3
model=$4

# set up the gridspec files
azores_grid="/home/users/benhutch/ERA5_psl/gridspec-azores.txt"
iceland_grid="/home/users/benhutch/ERA5_psl/gridspec-iceland.txt"
north_atlantic_grid="/home/users/benhutch/ERA5_psl/gridspec-north-atlantic.txt"

# set up an if loop for the location gridbox selection
if [ "$location" == "azores" ]; then
    # set the lat lon box
    lon1=-28
    lon2=-20
    lat1=36
    lat2=40
    # set the grid
    grid=$azores_grid
elif [ "$location" == "iceland" ]; then
    # set the lat lon box
    lon1=-25
    lon2=-16
    lat1=63
    lat2=70
    # set the grid
    grid=$iceland_grid
# for the North Atlantic region
elif [ "$location" == "NA" ]; then
    # set the lat lon box
    lon1=-80
    lon2=40
    lat1=20
    lat2=80
    # set the grid for the North Atlantic region
    grid=$north_atlantic_grid
else
    echo "[ERROR] Location not recognised"
    exit 1
fi

# set up an if loop for the model name
if [ "$model" == "HadGEM3-GC31-MM" ]; then
    model_group="MOHC"
elif [ "$model" == "EC-Earth3" ]; then
    model_group="EC-Earth-Consortium"
elif [ "$model" == "EC-Earth3-HR" ]; then
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

    echo "[INFO] Subsetting: $INPUT_FILE"
    fname=${location}-$(basename $INPUT_FILE)
    OUTPUT_FILE=$OUTPUT_DIR/$fname
    # perform the remapping to a 2.5x2.5 grid
    # select the gridbox and remap
    cdo sellonlatbox,$lon1,$lon2,$lat1,$lat2 -remapbil,$grid $INPUT_FILE $OUTPUT_FILE

done