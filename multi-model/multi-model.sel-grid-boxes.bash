#!/bin/bash

# multi-model.sel-grid-boxes.bash
#
# Usage: multi-model.sel-grid-boxes.bash <year> <run> <location> <model>    
#
# For example: multi-model.sel-grid-boxes.bash 1960 1 azores BCC-CSM2-MR

# get the year and run from the command line
year=$1
run=$2

# extract the location from the command line
location=$3

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

# get the model name from the command line
model=$4

# set up an if loop for the model name
if [model == "BCC-CSM2-MR"]; then
    model_group="BCC"
elif [model == "MPI-ESM1-2-HR"]
    model_group="MPI-M"
elif [model == "CanESM5"]
    model_group="CCCma"
elif [model == "CMCC-CM2-SR5"]
    model_group="CMCC"
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
# might run into issues with the ? in the path i?p?f?
files=/badc/cmip6/data/CMIP6/DCPP/$model_group/$model/dcppA-hindcast/s${year}-r${run}i?p?f?/Amon/psl/gn/files/d????????/*.nc

# activate the environment containing CDO
module load jaspy

# loop through the files and process them
for INPUT_FILE in $files; do

    echo "[INFO] Subsetting: $INPUT_FILE"
    fname=${location}-$(basename $INPUT_FILE)
    OUTPUT_FILE=$OUTPUT_DIR/$fname
    cdo sellonlatbox,$lon1,$lon2,$lat1,$lat2 $INPUT_FILE $OUTPUT_FILE

done

