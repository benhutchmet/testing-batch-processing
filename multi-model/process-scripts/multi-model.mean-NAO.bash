#!/bin/bash

# multi-model.mean-NAO.bash
#
# Usage: multi-model.mean-NAO.bash
#

# script to calculate the multi-model mean NAO index

# set the output directory
OUTPUT_DIR="/work/scratch-nopw/benhutch/multi-model"
# make this directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# set the files to be processed
# load the model data for all models
# apart from cnrm, EC-Earth3-HR and MRI-ESM2-0
BCC="/work/scratch-nopw/benhutch/BCC-CSM2-MR/nao-anomaly/nao-anomaly-BCC-CSM2-MR.nc"
CanESM5="/work/scratch-nopw/benhutch/CanESM5/nao-anomaly/nao-anomaly-CanESM5.nc"
CESM1="/work/scratch-nopw/benhutch/CESM1-1-CAM5-CMIP5/nao-anomaly/nao-anomaly-CESM1-1-CAM5-CMIP5.nc"
CMCC="/work/scratch-nopw/benhutch/CMCC-CM2-SR5/nao-anomaly/nao-anomaly-CMCC-CM2-SR5.nc"
EC="/work/scratch-nopw/benhutch/EC-Earth3/nao-anomaly/nao-anomaly-EC-Earth3.nc"
FGOALS="/work/scratch-nopw/benhutch/FGOALS-f3-L/nao-anomaly/nao-anomaly-FGOALS-f3-L.nc"
HadGEM3="/work/scratch-nopw/benhutch/HadGEM3-GC31-MM/nao-anomaly/nao-anomaly-HadGEM3-GC31-MM.nc"
IPSL="/work/scratch-nopw/benhutch/IPSL-CM6A-LR/nao-anomaly/nao-anomaly-IPSL-CM6A-LR.nc"
MIROC6="/work/scratch-nopw/benhutch/MIROC6/nao-anomaly/nao-anomaly-MIROC6.nc"
MPIHR="/work/scratch-nopw/benhutch/MPI-ESM1-2-HR/nao-anomaly/nao-anomaly-MPI-ESM1-2-HR.nc"
MPILR="/work/scratch-nopw/benhutch/MPI-ESM1-2-LR/nao-anomaly/nao-anomaly-MPI-ESM1-2-LR.nc"
NorCPM1="/work/scratch-nopw/benhutch/NorCPM1/nao-anomaly/nao-anomaly-NorCPM1.nc"

# append the models to a list
models=($BCC $CanESM5 $CESM1 $CMCC $EC $FGOALS $HadGEM3 $IPSL $MIROC6 $MPIHR $MPILR $NorCPM1)

# echo the list of models
echo ${models[@]}

# set the output file
OUTPUT_FILE=$OUTPUT_DIR/multi-model.mean-NAO.nc

# using cdo, calculate the multi-model mean
cdo ensmean ${models[@]} $OUTPUT_FILE