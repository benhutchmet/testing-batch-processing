#!/bin/bash

# script used for downloading the data from the ESGF server
# 
# Usage: bash download_script_GPT4_test.bash
#

# import the models.bash file
# remember to reupload this!
source /home/users/benhutch/multi-model/models.bash
# echo the lists to be used
echo "models to be downloaded from CEDA: $CEDA_models"
echo "models to be downloaded from ESGF: $ESGF_models"

# set the constants for the url to be used
# for the CEDA models
project="CMIP6"
experiment_id="dcppA-hindcast"
table_id="Amon"
variable_id="psl"
limit=8000
data_node="esgf.ceda.ac.uk"

# set the directory to download wget scripts to
wget_scripts_dir="/home/users/benhutch/multi-model/download_scripts/wget_scripts/"

# loop over the CEDA models
for model in $CEDA_models ; do
    
    echo "For the CEDA models: $CEDA_models"
    echo "Downloading wget script for $model"

    # set the source_id
    source_id=$model
    # construct the url
    url="https://esgf-data.dkrz.de/esg-search/wget?project=$project&experiment_id=$experiment_id&source_id=$source_id&table_id=$table_id&variable_id=$variable_id&limit=$limit&data_node=$data_node"
    # set the wget script name
    wget_script="${wget_scripts_dir}${model}_wget_script.sh"
    # download the wget script
    wget -O $wget_script $url
    # make the script executable
    chmod +x $wget_script
    
done

# then loop over the ESGF models
for model in $ESGF_models ; do
    
    echo "For the ESGF models: $ESGF_models"
    echo "Downloading wget script for $model"

    # set the source_id
    source_id=$model
    # construct the url
    url="https://esgf-data.dkrz.de/esg-search/wget?project=$project&experiment_id=$experiment_id&source_id=$source_id&table_id=$table_id&variable_id=$variable_id&limit=$limit&data_node=$data_node"
    # set the wget script name
    wget_script="${wget_scripts_dir}${model}_wget_script.sh"
    # download the wget script
    wget -O $wget_script $url
    # make the script executable
    chmod +x $wget_script
    
done
