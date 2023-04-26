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

# set up the gridspec files
azores_grid="/home/users/benhutch/ERA5_psl/gridspec-azores.txt"
iceland_grid="/home/users/benhutch/ERA5_psl/gridspec-iceland.txt"

# if the location is azores
if [ $location == "azores" ]; then
    # set the dimensions of the gridbox
    lon1=-28
    lon2=-20
    lat1=36
    lat2=40
    # set the grid
    grid=$azores_grid
elif [ $location == "iceland" ]; then
    # set the dimensions of the gridbox
    lon1=-25
    lon2=-16
    lat1=63
    lat2=70
    # set the grid
    grid=$iceland_grid
else
    echo "Location must be azores or iceland"
    exit 1
fi

# set up the output file name
output_fname="ERA5.${location}-gridbox.psl.nc"
# set up the output file path
output_file="$OUTPUT_DIR/$output_fname"

# activate the environmnet containing CDO
module load jaspy

# first convert the grib file to netcdf
cdo -f nc copy $file $output_file

# set up the output file name
output_fname_remap="ERA5.${location}-gridbox-remap.psl.nc"
# remap the grid to the location specified
# using first order conservative remapping
# or would bilinear be better?
# set to a larger grid to comply with restrictions
cdo remapcon,$grid $output_file $OUTPUT_DIR/$output_fname_remap

# select the months DJFM and the gridbox
# set up the output file name
ERA5_DJFM_LOCATION_NC_FILE="ERA5.${location}-gridbox.psl.DJFM.nc"
cdo select,season=DJFM -sellonlatbox,$lon1,$lon2,$lat1,$lat2 $OUTPUT_DIR/$output_fname_remap $OUTPUT_DIR/$ERA5_DJFM_LOCATION_NC_FILE

# calculate the model mean state for all DJFM
# set up the output file name
model_mean_state="ERA5.${location}-gridbox.psl.DJFM.model-mean-state.nc"
cdo timmean $OUTPUT_DIR/$ERA5_DJFM_LOCATION_NC_FILE $OUTPUT_DIR/$model_mean_state

# subtract the model mean state from the data
# set up the output file name
output_fname="ERA5.${location}-gridbox.psl.DJFM.anomalies.nc"
cdo sub $OUTPUT_DIR/$ERA5_DJFM_LOCATION_NC_FILE $OUTPUT_DIR/$model_mean_state $OUTPUT_DIR/$output_fname

# shift the time axis by 3 months to calculate the DJFM means
# set up the output file name
final_output_fname="ERA5.${location}-gridbox.psl.DJFM.mean.anomalies.nc"
cdo yearmean -selmon,9,10,11,12 -shifttime,-3mo $OUTPUT_DIR/$output_fname $OUTPUT_DIR/$final_output_fname
