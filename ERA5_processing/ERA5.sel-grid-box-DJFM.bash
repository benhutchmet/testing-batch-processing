#!/bin/bash

# script to select the azores and iceland gridboxes
# from the ERA5 data
#
# Usage: bash ERA5.sel-grid-box-DJFM.bash <location> <baseline>
#
# For example: bash ERA5.sel-grid-box-DJFM.bash azores <obs>

# check that the correct number of arguments have been passed
if [ $# -ne 2 ]; then
    echo "Usage: bash ERA5.sel-grid-box-DJFM.bash <location>"
    exit 1
fi

# extract the location
location=$1
# extract the baseline
baseline=$2

# set the output directory
OUTPUT_DIR=/home/users/benhutch/ERA5_psl

# set the file to be processed 
file=/home/users/benhutch/ERA5_psl/adaptor.mars.internal-1669912474.882154-28712-3-70ecc8cf-50c6-4c45-967a-01d26ddaae07.grib

# set up the gridspec files
azores_grid="/home/users/benhutch/ERA5_psl/gridspec-azores.txt"
iceland_grid="/home/users/benhutch/ERA5_psl/gridspec-iceland.txt"

# import the model mean states
# for subtracting the model baseline
BCC_mms="/work/scratch-nopw/benhutch/BCC-CSM2-MR/${location}/outputs/model-mean-state/model-mean-state.nc"
CanESM_mms="/work/scratch-nopw/benhutch/CanESM5/${location}/outputs/model-mean-state/model-mean-state.nc"
CESM1_mms="/work/scratch-nopw/benhutch/CESM1-1-CAM5-CMIP5/${location}/outputs/model-mean-state/model-mean-state.nc"
CMCC_mms="/work/scratch-nopw/benhutch/CMCC-CM2-SR5/${location}/outputs/model-mean-state/model-mean-state.nc"
ECEarth3_mms="/work/scratch-nopw/benhutch/EC-Earth3/${location}/outputs/model-mean-state/model-mean-state.nc"
FGOALS_mms="/work/scratch-nopw/benhutch/FGOALS-f3-L/${location}/outputs/model-mean-state/model-mean-state.nc"
HadGEM3_mms="/work/scratch-nopw/benhutch/HadGEM3-GC31-MM/${location}/outputs/model-mean-state/model-mean-state.nc"
IPSL_mms="/work/scratch-nopw/benhutch/IPSL-CM6A-LR/${location}/outputs/model-mean-state/model-mean-state.nc"
MIROC_mms="/work/scratch-nopw/benhutch/MIROC6/${location}/outputs/model-mean-state/model-mean-state.nc"
MPIESMHR_mms="/work/scratch-nopw/benhutch/MPI-ESM1-2-HR/${location}/outputs/model-mean-state/model-mean-state.nc"
MPIESMLR_mms="/work/scratch-nopw/benhutch/MPI-ESM1-2-LR/${location}/outputs/model-mean-state/model-mean-state.nc"
NorCPM1_mms="/work/scratch-nopw/benhutch/NorCPM1/${location}/outputs/model-mean-state/model-mean-state.nc"

# set up the output file name
output_fname="${location}-multi-model-ensemble-mean-state.nc"
# set up the output file path
multi_model_ens_mean_state="$OUTPUT_DIR/$output_fname"

# format the model mean states into a single list
# for use in the cdo command
hindcast_model_mean_states="$BCC_mms $CanESM_mms $CESM1_mms $CMCC_mms $ECEarth3_mms $FGOALS_mms $HadGEM3_mms $IPSL_mms $MIROC_mms $MPIESMHR_mms $MPIESMLR_mms $NorCPM1_mms"

# echo $model_mean_states
echo "[INFO] Calculating multi-model ensemble mean state for $location"
echo "[INFO] Model mean states: $hindcast_model_mean_states"

# calculate the multi-model ensemble mean state
# for the location specified
cdo ensmean $hindcast_model_mean_states $multi_model_ens_mean_state

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
ERA5_model_mean_state="ERA5.${location}-gridbox.psl.DJFM.model-mean-state.nc"
cdo timmean $OUTPUT_DIR/$ERA5_DJFM_LOCATION_NC_FILE $OUTPUT_DIR/$ERA5_model_mean_state

# subtract the model mean state from the data
# set up the output file name
if [ $baseline == "model" ]; then
    echo "[INFO] Subtracting hindcast model mean state from ERA5 data"
    DJFM_anomalies="ERA5.${location}-gridbox.psl.DJFM.anomalies.hindcast-model-mean-state.nc"
    cdo sub $OUTPUT_DIR/$ERA5_DJFM_LOCATION_NC_FILE $multi_model_ens_mean_state $OUTPUT_DIR/$DJFM_anomalies
elif [ $baseline == "obs" ]; then
    echo "[INFO] Subtracting ERA5 model mean state from ERA5 data"
    DJFM_anomalies="ERA5.${location}-gridbox.psl.DJFM.anomalies.ERA5-model-mean-state.nc"
    cdo sub $OUTPUT_DIR/$ERA5_DJFM_LOCATION_NC_FILE $OUTPUT_DIR/$ERA5_model_mean_state $OUTPUT_DIR/$DJFM_anomalies
else
    echo "[ERROR] Baseline must be model or obs"
    exit 1
fi

# shift the time axis by 3 months to calculate the DJFM means
# set up the output file name
if [ $baseline == "model" ]; then
    echo "[INFO] Shifting time axis by 3 months to calculate DJFM means"
    shifttime="ERA5.${location}-gridbox.psl.DJFM.anomalies.hindcast-model-mean-state.shifted.nc"
    cdo yearmean -selmon,9,10,11,12 -shifttime,-3months $OUTPUT_DIR/$DJFM_anomalies $OUTPUT_DIR/$shifttime
elif [ $baseline == "obs" ]; then
    echo "[INFO] Shifting time axis by 3 months to calculate DJFM means"
    shifttime="ERA5.${location}-gridbox.psl.DJFM.anomalies.ERA5-model-mean-state.shifted.nc"
    cdo yearmean -selmon,9,10,11,12 -shifttime,-3months $OUTPUT_DIR/$DJFM_anomalies $OUTPUT_DIR/$shifttime
else
    echo "[ERROR] Baseline must be model or obs"
    exit 1
fi
