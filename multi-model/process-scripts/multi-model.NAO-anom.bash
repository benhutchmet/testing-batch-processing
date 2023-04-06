#!/bin/bash

# multi-model.NAO-anom.bash
#
# Usage: multi-model.NAO-anom.bash <model>
#
# For example: multi-model.NAO-anom.bash BCC-CSM2-MR

USAGE_MESSAGE="Usage: multi-model.NAO-anom.bash <model>"

# check that the correct number of arguments have been passed
if [ $# -ne 1 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# set the model
model=$1

# set the output directory
OUTPUT_DIR=/work/scratch-nopw/benhutch/$model/nao-anomaly
# make the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# set the files to be processed
azores=/work/scratch-nopw/benhutch/$model/azores/outputs/mergetime/*.nc
iceland=/work/scratch-nopw/benhutch/$model/iceland/outputs/mergetime/*.nc

# echo the files being processed
echo "azores file: $azores"
echo "iceland file: $iceland"

# activate the environment containing CDO
module load jaspy

# calculate the NAO anomaly
cdo sub -fldmean $azores -fldmean $iceland $OUTPUT_DIR/nao-anomaly-${model}.nc