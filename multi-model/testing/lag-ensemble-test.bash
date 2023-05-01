#!/bin/bash

# lag-ensemble-test.bash
#
# Usage: lag-ensemble-test.bash <location> <model> <run> <init>
#
# For example: lag-ensemble-test.bash azores BCC-CSM2-MR 1 1
#

USAGE_MESSAGE="Usage: lag-ensemble-test.bash <location> <model> <run> <init>"

# check that the correct number of arguments have been passed
if [ $# -ne 4 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# set the location, model, run and init
location=$1
model=$2
run=$3
init=$4

# set the output directory
OUTPUT_DIR=/work/scratch-nopw/benhutch/$model/$location/outputs/ind-members/lag-ensemble
# make the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# set the files to be processed
files=/work/scratch-nopw/benhutch/$model/$location/outputs/ind-members/ensemble-mean/time-mean-years-2-9-DJFM-anomalies-${location}-psl_Amon_${model}_dcppA-hindcast_s*-r${run}i${init}.nc

# echo the files being processed
echo $files

# activate the environment containing CDO
module load jaspy

# we want to create a lagged ensemble by combining the required forecast with the previous 3 forecasts
# for example, the years 2-9 forecasts in 1964 are combined with the years 2-9 forecasts in 1963, 1962 and 1961 by averaging
# with the year 2-9 forecasts in 1965 combined with the years 2-9 forecasts in 1964, 1963 and 1962 by averaging
for file in $files; do

    # extract the start year from the file name
    start_year=$(echo $file | grep -o -E 's[0-9]+' | sed 's/s//')

    # calculate the previous 3 years
    year1=$((start_year - 1))
    year2=$((start_year - 2))
    year3=$((start_year - 3))

    # construct the file paths for the previous 3 years
    file1=$(echo $file | sed "s/s${start_year}/s${year1}/")
    file2=$(echo $file | sed "s/s${start_year}/s${year2}/")
    file3=$(echo $file | sed "s/s${start_year}/s${year3}/")

    # check if all the required files exist
    if [ -f $file1 ] && [ -f $file2 ] && [ -f $file3 ]; then
        # combine the files and calculate the mean
        output_file=$OUTPUT_DIR/lag-ensemble-mean-years-2-9-DJFM-anomalies-${location}-psl_Amon_${model}_dcppA-hindcast_s${start_year}-r${run}i${init}.nc
        cdo ensmean $file $file1 $file2 $file3 $output_file
        echo "Lagged ensemble mean created for start year: $start_year"
    else
        echo "One or more required files for start year $start_year not found. Skipping this year."
    fi

done