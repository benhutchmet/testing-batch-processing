#!/bin/bash

# submit-all-wrapper-script.bash
#
# Usage: submit-all-wrapper-script.bash <model> <start-year> <finish-year>
#
# This script is a wrapper script for the submit-all scripts for the multi-model
#
# For example: submit-all-wrapper-script.bash BCC-CSM2-MR 1961 2014

USAGE_MESSAGE="Usage: submit-all-wrapper-script.bash <model> <start-year> <finish-year>"

# check that the correct number of arguments have been passed
if [ $# -ne 3 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# extract the model, start year and finish year
model=$1
start_year=$2
finish_year=$3

# set up the extractor
EXTRACTOR=$PWD/wrapper-script-calculate-nao.bash
OUTPUT_DIR=/work/scratch-nopw/benhutch/$model/outputs/ensemble-mean
