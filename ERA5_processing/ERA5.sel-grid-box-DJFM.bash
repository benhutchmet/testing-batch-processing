#!/bin/bash

# script to select the azores and iceland gridboxes
# from the ERA5 data
#
# Usage: bash ERA5.sel-grid-box-DJFM.bash <location>
#
# For example: bash ERA5.sel-grid-box-DJFM.bash azores

# check that the correct number of arguments have been passed
if [ $# -ne 1 ]; then
    echo "Usage: bash ERA5.sel-grid-box-DJFM.bash <location>"
    exit 1
fi

# extract the location
location=$1

# set the output directory
OUTPUT_DIR=/home/users/benhutch/ERA5_psl

# set the file to be processed 
file=/home/users/benhutch/ERA5_psl/adaptor.mars.internal-1669912474.882154-28712-3-70ecc8cf-50c6-4c45-967a-01d26ddaae07.grib

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

# set up the output file name
output_fname="ERA5.${location}-gridbox.psl.nc"
# set up the output file path
output_file="$OUTPUT_DIR/$output_fname"

# activate the environmnet containing CDO
module load jaspy

# select the gridbox and months DJFM
cdo select,season=DJFM -sellonlatbox,$lon1,$lon2,$lat1,$lat2 $file $output_file

# calculate the model mean state for all DJFM
# set up the output file name
model_mean_state="ERA5.${location}-gridbox.psl.DJFM.model-mean-state.nc"
cdo timmean $output_file $OUTPUT_DIR/$model_mean_state

# subtract the model mean state from the data
# set up the output file name
output_fname="ERA5.${location}-gridbox.psl.DJFM.anomalies.nc"
cdo sub $output_file $OUTPUT_DIR/$model_mean_state $OUTPUT_DIR/$output_fname


