#!/bin/bash

# ERA5.calc.8yrRM.NAO.bash
#
# Script for calculating the NAO index from ERA5 data
# Azores - Iceland
# and taking a forward running mean of 8 years
# so that the value for 1960 is the mean of 1961-1968


# set up the files to be processed
azores="/home/users/benhutch/ERA5_psl/ERA5.azores-gridbox.psl.DJFM.anomalies.hindcast-model-mean-state.shifted.nc"
iceland="/home/users/benhutch/ERA5_psl/ERA5.iceland-gridbox.psl.DJFM.anomalies.hindcast-model-mean-state.shifted.nc"

# load the module containing CDO
module load jaspy

# set up the output directory
OUTPUT_DIR="/home/users/benhutch/ERA5_psl/nao-anomaly"
# make the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# calculate the NAO anomaly
cdo sub -fldmean $azores -fldmean $iceland $OUTPUT_DIR/nao-anomaly-ERA5-hindcast-BL.nc

# take a forward running mean of 8 years
# shift the time axis by 4 years 1964 - 1960
cdo runmean,8 $OUTPUT_DIR/nao-anomaly-ERA5-hindcast-BL.nc $OUTPUT_DIR/nao-anomaly-ERA5-hindcast-BL.8yrRM.nc