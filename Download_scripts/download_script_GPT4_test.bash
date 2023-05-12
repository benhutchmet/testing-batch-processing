#!/bin/bash

# script used for downloading the data from the ESGF server
# 
# Usage: bash download_script_GPT4_test.bash
#

# import the models.bash file
# remember to reupload this!
source /home/users/benhutch/multi-model/models.bash
# echo the lists to be used
echo  "[INFO] Models to be downloaded: $ESGF_models"
echo  "[INFO] Nodes to be downloaded from: $ESGF_nodes"

# models and nodes correspond

# set the constants for the url to be used
# for the CEDA models
project="CMIP6"
experiment_id="dcppA-hindcast"
table_id="Amon"
# variable_id="psl"
variables_id=("sfcWind" "tas" "rsds")
limit=10000

# echo the characteristics of the data to be downloaded
echo "[INFO] Project: $project"
echo "[INFO] Experiment: $experiment_id"
echo "[INFO] Table: $table_id"
echo "[INFO] Variable: $variables_id"
echo "[INFO] Limit: $limit"

# set the directory to download wget scripts to
wget_scripts_dir="/home/users/benhutch/multi-model/download_scripts/wget_scripts/"

# loop over the variables
for variable_id in "${variables_id[@]}"; do

    # echo the variable
    echo "[INFO] Variable: $variable_id"

    # set up the ESGF model and node to be used depending on the variable
    if [ "$variable_id" == "sfcWind" ]; then
        # loop over the models and nodes
        # and download the wget scripts
        # for the surface wind variable
        for ((i=0; i<${#wind_speed_ESGF_models[@]}; i++)); do

            # set the model and node
            model=${wind_speed_ESGF_models[i]}
            node=${wind_speed_ESGF_nodes[i]}

            # echo the model and node
            echo "[INFO] Downloading wget script for $model from $node for variable $variable_id"

            # set the url
            url="https://esgf-data.dkrz.de/esg-search/wget?project=$project&experiment_id=$experiment_id&source_id=$model&table_id=$table_id&variable_id=$variable_id&limit=$limit&data_node=$node"
            
            # set the wget script name
            wget_script_name="wget_script_${model}_${variable_id}.bash"
            # set the wget script path
            wget_script_path="$wget_scripts_dir$wget_script_name"
            
            # echo the url
            echo "[INFO] URL: $url"

            # download the wget script
            wget -O $wget_script_path $url
            # make the wget script executable
            chmod +x $wget_script_path

        done
    elif [ "$variable_id" == "tas" ]; then
        # loop over the models and nodes
        # and download the wget scripts
        # for the temperature variable
        for ((i=0; i<${#tas_ESGF_models[@]}; i++)); do

            # set the model and node
            model=${tas_ESGF_models[i]}
            node=${tas_ESGF_nodes[i]}

            # echo the model and node
            echo "[INFO] Downloading wget script for $model from $node for variable $variable_id"

            # set the url
            url="https://esgf-data.dkrz.de/esg-search/wget?project=$project&experiment_id=$experiment_id&source_id=$model&table_id=$table_id&variable_id=$variable_id&limit=$limit&data_node=$node"
            
            # set the wget script name
            wget_script_name="wget_script_${model}_${variable_id}.bash"
            # set the wget script path
            wget_script_path="$wget_scripts_dir$wget_script_name"
            
            # echo the url
            echo "[INFO] URL: $url"

            # download the wget script
            wget -O $wget_script_path $url
            # make the wget script executable
            chmod +x $wget_script_path

        done
    elif [ "$variable_id" == "rsds" ]; then
        # loop over the models and nodes
        # and download the wget scripts
        # for the surface solar radiation variable
        for ((i=0; i<${#rsds_ESGF_models[@]}; i++)); do

            # set the model and node
            model=${rsds_ESGF_models[i]}
            node=${rsds_ESGF_nodes[i]}

            # echo the model and node
            echo "[INFO] Downloading wget script for $model from $node for variable $variable_id"

            # set the url
            url="https://esgf-data.dkrz.de/esg-search/wget?project=$project&experiment_id=$experiment_id&source_id=$model&table_id=$table_id&variable_id=$variable_id&limit=$limit&data_node=$node"
            
            # set the wget script name
            wget_script_name="wget_script_${model}_${variable_id}.bash"
            # set the wget script path
            wget_script_path="$wget_scripts_dir$wget_script_name"
            
            # echo the url
            echo "[INFO] URL: $url"

            # download the wget script
            wget -O $wget_script_path $url
            # make the wget script executable
            chmod +x $wget_script_path

        done
    else
        echo "[ERROR] Variable not recognised"
        exit 1
    fi 
done