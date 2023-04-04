#!/bin/bash

# combine_anom_test.bash
#
# Usage: combine_anom_test.bash <location> <year>
#

# set the location
location=$1

# set the year
year=$2

# set the output directory
OUTPUT_DIR=/home/users/benhutch/BCC-CSM2-MR/$location/combine-anom-test

# make the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# set the files to be processed
files=/home/users/benhutch/BCC-CSM2-MR/$location/ensmean-year-2-9-anomaly/subtracted-model-mean-years-2-9-DJFM-${location}-psl_Amon_BCC-CSM2-MR_dcppA-hindcast_s${year}*.nc

# echo the files to be processed
echo "[INFO] files to be processed: $files"

# activate the environment containing CDO
module load jaspy

# set up the ensemble mean name
fname_ensmean=ensmean-year-2-9-anomaly-${year}.nc
OUTPUT_FILE_ENSMEAN=$OUTPUT_DIR/$fname_ensmean

# calculate the ensemble mean
cdo ensmean $files $OUTPUT_FILE_ENSMEAN