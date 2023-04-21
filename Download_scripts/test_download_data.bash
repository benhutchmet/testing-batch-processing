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
# specify the subset of the data to download
# http://esgf-data.dkrz.de/esg-search/wget?experiment=decadal2000&variable=tas&limit=2000&download_structure=project,product,institute,model,experiment,time_frequency,realm,cmor_table,ensemble,variable

