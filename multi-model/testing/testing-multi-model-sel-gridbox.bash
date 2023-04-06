#!/bin/bash

# testing-multi-model-sel-gridbox.bash
#
# Usage:  testing-multi-model-sel-gridbox.bash <year> <run> <location> <model_group> <model>
# For example: testing-multi-model-sel-gridbox.bash 1960 1 azores CMCC CMCC-CM2-SR5

# set the partition/account arguments for LOTUS based on usage context
# SBATCH --partition=short-serial

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

# get the model name and group from the command line
model_group=$4
model=$5

# set up the output directory
# in the scratch-nopw directory
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