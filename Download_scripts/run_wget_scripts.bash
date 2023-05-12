#!/bin/bash

# Usage: bash run_wget_scripts.bash <variable>

# load the models.bash file
source /home/users/benhutch/multi-model/models.bash

# exctract the variable from the command line
var=$1

# Define the directory containing the wget scripts
# make sure that these are the modified wget scripts
WGET_SCRIPTS_DIR="/home/users/benhutch/multi-model/download_scripts/wget_scripts"

# Function to display elapsed time in a human-readable format
function display_duration() {
    local T=$1
    local D=$((T/60/60/24))
    local H=$((T/60/60%24))
    local M=$((T/60%60))
    local S=$((T%60))
    (( D > 0 )) && printf '%d days ' $D
    (( H > 0 )) && printf '%d hours ' $H
    (( M > 0 )) && printf '%d minutes ' $M
    (( D > 0 || H > 0 || M > 0 )) && printf 'and '
    printf '%d seconds\n' $S
}

# # if else statement to determine which models to run
# if [ "$var" == "sfcWind" ]; then
#     # set the models to run
#     models=$wind_speed_ESGF_models
# elif [ "$var" == "tas" ]; then
#     # set the models to run
#     models=$tas_ESGF_models
# elif [ "$var" == "rsds" ]; then
#     # set the models to run
#     models=$rsds_ESGF_models
# else
#     echo "Variable not recognised. Please choose from: sfcWind, tas"
#     exit 1
# fi


# Execute each wget script and print progress with elapsed time
# CNRM not working for now
start_time=$(date +%s)
for script in "$WGET_SCRIPTS_DIR"/wget_script_*_"$var".bash; do
    
    model_name=$(basename "$script" | sed 's/^wget_script_//' | sed 's/\.bash$//')
    echo "Downloading $model_name data..."
    script_start_time=$(date +%s)
    bash "$script" -H
    script_end_time=$(date +%s)
    script_duration=$((script_end_time - script_start_time))
    echo "$model_name download completed. Time taken: $(display_duration $script_duration)"

    current_time=$(date +%s)
    total_duration=$((current_time - start_time))
    echo "Current runtime: $(display_duration $total_duration)"
    echo " "
done
