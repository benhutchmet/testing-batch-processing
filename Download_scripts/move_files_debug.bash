#!/bin/bash

# Usage: bash move_files.bash <variable>

# Enable debugging
set -x

# Load the models.bash file
source /home/users/benhutch/multi-model/models.bash || { echo "Failed to source models.bash"; exit 1; }

# Get the argument
arg=$1
echo "Argument: $arg"

# Based on the argument, assign the appropriate variable
if [ "$arg" = "sfcWind" ]; then
    models=("${wind_speed_ESGF_models[@]}")
elif [ "$arg" = "tas" ]; then
    models=("${tas_ESGF_models[@]}")
elif [ "$arg" = "rsds" ]; then
    models=("${rsds_ESGF_models[@]}")
else
    echo "Unsupported argument"
    exit 1
fi

# Print models
echo "Models: ${models[@]}"

# Iterate over the models
for model in "${models[@]}"; do
    echo "Processing model: $model"
    # Create a directory for each model if it doesn't exist
    if [ ! -d "$model" ]; then
        echo "Directory $model does not exist. Creating it."
        mkdir "$model"
    else
        echo "Directory $model already exists."
    fi

    # Check if there are .nc files to move
    if ls *"$model"*.nc 1> /dev/null 2>&1; then
        echo "Moving .nc files for model $model"
        # Move each .nc file containing the model name into its namesake folder
        mv *"$model"*.nc "$model"/
    else
        echo "No .nc files to move for model $model"
    fi
done

# Disable debugging
set +x
