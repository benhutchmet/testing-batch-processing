#!/bin/bash

# Define the usage message
USAGE_MESSAGE="Usage: multi-model.year-2-9-DJFM.bash <location> <model>"

# Check the number of command-line arguments
if [ $# -ne 2 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# Extract the model and location from the command-line arguments
location=$1
model=$2

# Set the output directory
OUTPUT_DIR="/work/scratch-nopw/benhutch/$model/$location/outputs"

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Set the input files
files="/work/scratch-nopw/benhutch/$model/$location/outputs/*.nc"

# Load the module containing CDO
module load jaspy

# Loop through the input files
for INPUT_FILE in $files; do

    # Print a message
    echo "[INFO] Creating years 2-9 DJFM files: $INPUT_FILE"

    # Set the output file names
    fname="years-2-9-DJFM-$(basename "$INPUT_FILE")"
    temp_fname="temp-$(basename "$INPUT_FILE")"
    OUTPUT_FILE="$OUTPUT_DIR/$fname"
    TEMP_FILE="$OUTPUT_DIR/$temp_fname"

    # Extract the initialization year from the input file name
    year=$(basename "$INPUT_FILE" | sed 's/.*_s\([0-9]\{4\}\)-.*/\1/')

    # Calculate the start and end dates for the DJFM season
    start_date=$((year + 1))"-12-01"
    end_date=$((year + 9))"-03-31"

    # Constrain the input file to the DJFM season
    cdo select,season=DJFM "$INPUT_FILE" "$TEMP_FILE"

    # Extract the 2-9 years using cdo
    cdo select,startdate="$start_date",enddate="$end_date" "$TEMP_FILE" "$OUTPUT_FILE"

    # Remove the temporary file
    rm "$TEMP_FILE"

done
