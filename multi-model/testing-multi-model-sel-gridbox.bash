#!/bin/bash

# testing-multi-model-sel-gridbox.bash
#
# Usage:  testing-multi-model-sel-gridbox.bash <year> <run> <location> <model>
#

# set the partition/account arguments for LOTUS based on usage context
# SBATCH --partition=short-serial

# get the year and run from the command line
year=$1
run=$2

# set up an if loop for the location gridbox selection
if [ $3 == "azores" ]; then
    lon1=-28
    lon2=-20
    lat1=36
    lat2=40
elif [ $3 == "iceland" ]; then
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
OUTPUT_DIR=/work/scratch-nopw/benhutch/$model/$3/outputs
# make the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# set the files to be processed
files=/badc/cmip6/data/CMIP6/DCPP/$model_group/$model/dcppA-hindcast/s${year}-r${run}i1p1f1/Amon/psl/gn/files/d????????/*.nc