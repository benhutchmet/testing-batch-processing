#!/bin/bash

# multi-model.sel-grid-boxes.bash
#
# Usage: multi-model.sel-grid-boxes.bash <year> <run> <location> <model>    
#
# For example: multi-model.sel-grid-boxes.bash 1960 1 azores BCC-CSM2-MR
#

# get the year and run from the command line
year=$1
run=$2

# extract the location from the command line
location=$3

# set up the gridspec files
azores_grid="/home/users/benhutch/ERA5_psl/gridspec-azores.txt"
iceland_grid="/home/users/benhutch/ERA5_psl/gridspec-iceland.txt"

# set up an if loop for the location gridbox selection
if [ "$location" == "azores" ]; then
    # set the dimensions of the gridbox
    lon1=-28
    lon2=-20
    lat1=36
    lat2=40
    # set the grid file
    grid=$azores_grid
elif [ "$location" == "iceland" ]; then
    # set the dimensions of the gridbox
    lon1=-25
    lon2=-16
    lat1=63
    lat2=70
    # set the grid file
    grid=$iceland_grid
else
    echo "[ERROR] Location not recognised"
    exit 1
fi

# get the model name from the command line
model=$4

# set up an if loop for the model name
if [ "$model" == "BCC-CSM2-MR" ]; then
    model_group="BCC"
elif [ "$model" == "MPI-ESM1-2-HR" ]; then
    model_group="MPI-M"
elif [ "$model" == "CanESM5" ]; then
    model_group="CCCma"
elif [ "$model" == "CMCC-CM2-SR5" ]; then
    model_group="CMCC"
elif [ "$model" == "HadGEM3-GC31-MM" ]; then
    model_group="MOHC"
elif [ "$model" == "EC-Earth3" ]; then
    model_group="EC-Earth-Consortium"
elif [ "$model" == "EC-Earth3-HR" ]; then
    model_group="EC-Earth-Consortium"
elif [ "$model" == "MRI-ESM2-0" ]; then
    model_group="MRI"
elif [ "$model" == "MPI-ESM1-2-LR" ]; then
    model_group="DWD"
elif [ "$model" == "FGOALS-f3-L" ]; then
    model_group="CAS"
elif [ "$model" == "CNRM-ESM2-1" ]; then
    model_group="CNRM-CERFACS"
elif [ "$model" == "MIROC6" ]; then
    model_group="MIROC"
elif [ "$model" == "IPSL-CM6A-LR" ]; then
    model_group="IPSL"
elif [ "$model" == "CESM1-1-CAM5-CMIP5" ]; then
    model_group="NCAR"
elif [ "$model" == "NorCPM1" ]; then
    model_group="NCC"
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
# depends on whether the final directory contains one single file or multiple files
# for the single file models store on JASMIN
if [ "$model" == "BCC-CSM2-MR" ] || [ "$model" == "MPI-ESM1-2-HR" ] || [ "$model" == "CanESM5" ] || [ "$model" == "CMCC-CM2-SR5" ]; then
    files="/badc/cmip6/data/CMIP6/DCPP/$model_group/$model/dcppA-hindcast/s${year}-r${run}i?p?f?/Amon/psl/gn/files/d????????/*.nc"
# for the single file models downloaded from ESGF
elif  [ "$model" == "MRI-ESM2-0" ] || [ "$model" == "MPI-ESM1-2-LR" ] || [ "$model" == "FGOALS-f3-L" ] || [ "$model" == "CNRM-ESM2-1" ] || [ "$model" == "MIROC6" ] || [ "$model" == "IPSL-CM6A-LR" ] || [ "$model" == "CESM1-1-CAM5-CMIP5" ] || [ "$model" == "NorCPM1" ]; then
    # check that this returns the files
    files="/work/xfc/vol5/user_cache/benhutch/$model_group/$model/psl_Amon_${model}_dcppA-hindcast_s${year}-r${run}i*p*f*_g*_*.nc"
else
    echo "[ERROR] Model not recognised"
    exit 1
fi

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

    # remove the temporary file
    rm $TEMP_FILE

done

