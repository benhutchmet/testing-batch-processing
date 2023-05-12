#!/bin/bash

# Usage: bash move_files.bash <variable>

# Load the models.bash file
source /home/users/benhutch/multi-model/models.bash

# Get the argument
arg=$1

# Based on the argument, assign the appropriate variable
if [ "$arg" = "sfcWind" ]; then
    models=${wind_speed_esgf_models[@]}
elif [ "$arg" = "tas" ]; then
    models=${tas_esgf_models[@]}
elif [ "$arg" = "rsds" ]; then
    models=${rsds_esgf_models[@]}
else
    echo "Unsupported argument"
    exit 1
fi

# Iterate over the models
for model in ${models[@]}; do
    # Create a directory for each model if it doesn't exist
    if [ ! -d "$model" ]; then
        mkdir "$model"
    fi

    # Move each .nc file containing the model name into its namesake folder
    mv *"$model"*.nc "$model"/
done
