#!/bin/bash

# multi-model.mergetime.ind-ens-members.bash
#
# For example: multi-model.mergetime.ind-ens-members.bash azores BCC-CSM2-MR 1 1 nolag
#

USAGE_MESSAGE="Usage: multi-model.mergetime.bash <location> <model> <run> <init> <lag>"

# check that the correct number of arguments have been passed
if [ $# -ne 5 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# set the location and model
location=$1
model=$2

# set the run and init
run=$3
init=$4
lag=$5

# set the output directory
OUTPUT_DIR=/work/scratch-nopw/benhutch/$model/$location/outputs/ind-members/mergetime
# make the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# set the files to be processed
# in the nolag case
if [ $lag == "nolag" ]; then
    files=/work/scratch-nopw/benhutch/$model/$location/outputs/ind-members/ensemble-mean/time-mean-years-2-9-DJFM-anomalies-${location}-psl_Amon_${model}_dcppA-hindcast_s*-r${run}i${init}.nc
# in the lag case
elif [ $lag == "lag" ]; then
    files=/work/scratch-nopw/benhutch/$model/$location/outputs/ind-members/lag-ensemble/lag-ensemble-mean-years-2-9-DJFM-anomalies-${location}-psl_Amon_${model}_dcppA-hindcast_s*-r${run}i${init}.nc
fi

# echo the files being processed
echo $files

# activate the environment containing CDO
module load jaspy

# set up the filename for the merged file
merged_fname="merged-time-mean-years-2-9-DJFM-anomalies-${location}-psl_Amon_dcppA-hindcast-${model}_r${run}i${init}-${lag}.nc"
# set up the path for the merged file
merged_file="$OUTPUT_DIR/$merged_fname"

# merge the files
cdo mergetime $files $merged_file