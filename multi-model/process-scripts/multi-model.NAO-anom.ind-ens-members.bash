#!/bin/bash

# multi-model.NAO-anom.ind-ens-members.bash
#
# Usage: multi-model.NAO-anom.ind-ens-members.bash <model> <run> <init>
#
# For example: multi-model.NAO-anom.bash BCC-CSM2-MR 1 1

USAGE_MESSAGE="Usage: multi-model.NAO-anom.bash <model> <run> <init>"

# check that the correct number of arguments have been passed
if [ $# -ne 3 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# set the model run and init
model=$1
run=$2
init=$3

# set the output directory
OUTPUT_DIR=/work/scratch-nopw/benhutch/$model/nao-anomaly/ind-members
# make the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# set the files to be processed
azores=/work/scratch-nopw/benhutch/$model/$location/outputs/ind-members/mergetime/*.nc
iceland=/work/scratch-nopw/benhutch/$model/$location/outputs/ind-members/mergetime/*.nc

# echo the files being processed
echo "azores file: $azores"
echo "iceland file: $iceland"

# activate the environment containing CDO
module load jaspy

# calculate the NAO anomaly
cdo sub -fldmean $azores -fldmean $iceland $OUTPUT_DIR/nao-anomaly-${model}_r${run}i${init}.nc