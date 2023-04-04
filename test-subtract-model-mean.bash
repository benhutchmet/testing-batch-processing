#!/bin/bash

# test-subtract-model-mean.bash
#
# Usage: test-subtract-model-mean.bash
#

# set the location
location=azores

# set the year
year=1961

# files will be given by:
# years-2-9-DJFM-iceland-psl_Amon_BCC-CSM2-MR_dcppA-hindcast_s2014-r8i1p1f1_gn_201401-202312.nc
# or
# years-2-9-DJFM-azores-psl_Amon_BCC-CSM2-MR_dcppA-hindcast_s2014-r8i1p1f1_gn_201401-202312.nc
# in the output directory
# home/users/benhutch/BCC-CSM2-MR/azores/outputs

# and model mean state
# home/users/benhutch/BCC-CSM2-MR/azores/model-mean-state/model-men-state.nc

# set the output directory
OUTPUT_DIR=/home/users/benhutch/BCC-CSM2-MR/$location/subtract-model-mean-test
# make the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# set the files to be processed
# we only want to extract the files constrained to years 2-9 DJFM
# for the year we are interested in
files=/home/users/benhutch/BCC-CSM2-MR/$location/outputs/years-2-9-DJFM-azores-psl_Amon_BCC-CSM2-MR_dcppA-hindcast_s${year}*.nc

# extract the model mean state
model_mean_state=/home/users/benhutch/BCC-CSM2-MR/$location/model-mean-state/model-mean-state.nc

# check that we have the right files
echo "We are going to process the following files: $files"

# activate the environment containing CDO
module load jaspy


# set up the ensemble mean name
fname_ensmean=ensmean-year-2-9-anomaly-${year}.nc
OUTPUT_FILE_ENSMEAN=$OUTPUT_DIR/$fname_ensmean

# initialize a for loop
# which loops over each of the ensemble members
for INPUT_FILE in $files; do

    echo "[INFO] Subtracting model mean state: $INPUT_FILE"
    fname=subtracted-model-mean-$(basename $INPUT_FILE)
    OUTPUT_FILE=$OUTPUT_DIR/$fname

    # use grep and cut to extract the number 7 from the file path
    ensemble_member=$(echo $INPUT_FILE | grep -o 'r[0-9]*' | cut -c2-)
    # use grep and sed to extract the initialization year from the file path
    init_year=$(echo $INPUT_FILE | grep -o 's[0-9]*' | sed 's/s//')

    # print the extracted ensemble member
    echo "[INFO] subtracting model mean state for ensemble member: $ensemble_member"

    # print the extracted initialization year
    echo "[INFO] subtracting model mean state for initialization year: $init_year"

    # subtract the model mean state
    cdo sub $INPUT_FILE $model_mean_state $OUTPUT_FILE

done

# take the ensemble mean of all of these files
# to get the year 2-9 DJFM ensemble mean anomalies
# for one start date
cdo ensmean $OUTPUT_DIR/subtracted-model-mean*.nc $OUTPUT_FILE_ENSMEAN