#!/bin/bash

# BCC-CSM2-MR.time-mean.bash
#
# Usage: BCC-CSM2-MR.time-mean.bash <location> <year>
#

# set the location
location=$1

# set the year
year=$2

# set the output directory
OUTPUT_DIR=/home/users/benhutch/BCC-CSM2-MR/$location/time-mean
# make the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# set the files to be processed
files=/home/users/benhutch/BCC-CSM2-MR/$location/combine-anom/ensmean-year-2-9-anomaly-${year}.nc

# activate the environment containing CDO
module load jaspy

# calculate the time mean
cdo timmean $files $OUTPUT_DIR/time-mean-${year}.nc
