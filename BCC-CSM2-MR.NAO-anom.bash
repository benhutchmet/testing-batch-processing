#!/bin/bash

# BCC-CSM2-MR.NAO-anom.bash
#
# Usage: BCC-CSM2-MR.NAO-anom.bash
#

# set the output directory
OUTPUT_DIR=/home/users/benhutch/BCC-CSM2-MR/NAO_anomaly
# make the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# set the files to be processed
azores=/home/users/benhutch/BCC-CSM2-MR/azores/mergetime/merged_dataset_BCC-CSM2-MR_1961-2014-azores.nc

iceland=/home/users/benhutch/BCC-CSM2-MR/iceland/mergetime/merged_dataset_BCC-CSM2-MR_1961-2014-iceland.nc

# ensure that the cdo environment is loaded
module load jaspy

# calculate the NAO anomaly
cdo sub -fldmean $azores -fldmean $iceland $OUTPUT_DIR/NAO_anomaly.nc