#!/bin/bash

# script used for downloading the data from the ESGF server
# specifically the LLNL server
#
# Path: Download_scripts\download_data.sh
#

# set download directory
download_dir=/work/xfc/vol5/user_cache/benhutch/NCAR/CESM1-1-CAM5-CMIP5

# set search parameters
project=CMIP6
experiment=dcppA-hindcast
time_frequency=mon
variable=psl
institution_id=NCAR
source_id=CESM1-CAM5-CMIP5

# generate URL for wget script
url="https://esgf-node.llnl.gov/esg-search/wget?project=$project&experiment=$experiment&time_frequency=$time_frequency&variable=$variable&institution_id=$institution_id&source_id=$source_id"


# Set download directory
download_dir=/path/to/download/directory

# Set search parameters
project=CMIP6
experiment=historical
time_frequency=mon
variable=tas
institution_id=IPSL
source_id=IPSL-CM6A-LR
member_id=r1i1p1f1

# Generate URL for wget script
url="https://esgf-node.llnl.gov/esg-search/wget?project=$project&experiment=$experiment&time_frequency=$time_frequency&variable=$variable&institution_id=$institution_id&source_id=$source_id&member_id=$member_id"

# Create wget script and download data
wget --no-check-certificate --content-disposition --recursive --level=1 --accept .nc -P $download_dir $url

# this one works for CMIP6
https://esgf-data.dkrz.de/esg-search/wget?project=CMIP6&experiment_id=dcppA-hindcast&source_id=HadGEM3-GC31-MM&table_id=Amon&variable_id=psl&limit=8000

https://claut.gitlab.io/man_ccia/lab2.html