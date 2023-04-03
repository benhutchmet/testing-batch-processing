#!/bin/bash

# BCC-CSM2-MR.calc-sub-bl.bash
#
# Usage:    BCC-CSM2-MR.calc-sub-bl.bash <location>
#

# extract the location
location=$1


# file will be given by:
# azores-psl_Amon_BCC-CSM2-MR_dcppA-hindcast_s1961-r1i1p1f1_gn_196101-197012.nc
# or
# iceland-psl_Amon_BCC-CSM2-MR_dcppA-hindcast_s1961-r1i1p1f1_gn_196101-197012.nc

# set the output directory
OUTPUT_DIR=/home/users/benhutch/BCC-CSM2-MR/$location/baseline-removed
# make the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# set the files to be processed
files=/home/users/benhutch/BCC-CSM2-MR/$location/outputs/*.nc

# activate the environment containing CDO
module load jaspy

# first we want to calculate the model mean state
# for BCC-CSM2-MR
# for all ensemble members (10)
# for all start dates (1961-2014)
# for hindcast years 2-9 (1961-2014)