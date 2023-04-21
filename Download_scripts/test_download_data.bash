#!/bin/bash

# test_download_data.bash
#
# test script for downloading data from the ESGF server
# specifically the LLNL server
#

# set download directory
download_dir=/work/xfc/vol5/user_cache/benhutch/test_download
# make the download directory
mkdir -p $download_dir

# set search parameters
project=CMIP6
experiment=dcppA-hindcast
time_frequency=mon
variable=psl
institution_id=NCAR
source_id=CESM1-CAM5-CMIP5

# generate URL for wget script
url="https://esgf-node.llnl.gov/esg-search/wget?project=$project&experiment=$experiment&time_frequency=$time_frequency&variable=$variable&institution_id=$institution_id&source_id=$source_id"

# echo the characteristics of the data to be downloaded
echo "[INFO] Downloading data from: $url"
echo "[INFO] Downloading data to: $download_dir"
echo "[INFO] Project: $project"
echo "[INFO] Experiment: $experiment"
echo "[INFO] Time Frequency: $time_frequency"
echo "[INFO] Variable: $variable"
echo "[INFO] Institution ID: $institution_id"
echo "[INFO] Source ID: $source_id"

# Create wget script and download data
wget --no-check-certificate --content-disposition --recursive --level=1 --accept .nc -P $download_dir $url

