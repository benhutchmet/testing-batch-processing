#!/bin/bash

# models.bash
# file containing the list of models to be processed

# list of models
# available on JASMIN
models="BCC-CSM2-MR MPI-ESM1-2-HR CanESM5 CMCC-CM2-SR5 HadGEM3-GC31-MM EC-Earth3 EC-Earth3-HR MRI-ESM2-0 MPI-ESM1-2-LR FGOALS-f3-L CNRM-ESM2-1 MIROC6 IPSL-CM6A-LR CESM1-1-CAM5-CMIP5 NorCPM1"

single_file_models="BCC-CSM2-MR MPI-ESM1-2-HR CanESM5 CMCC-CM2-SR5 MRI-ESM2-0 MPI-ESM1-2-LR FGOALS-f3-L CNRM-ESM2-1 MIROC6 IPSL-CM6A-LR CESM1-1-CAM5-CMIP5 NorCPM1"

multi_file_models="HadGEM3-GC31-MM EC-Earth3 EC-Earth3-HR"

# models downloaded from CEDA/LLNL ESGF server to xfer
# format these as arrays
ESGF_models=("NorCPM1" "EC-Earth3-HR" "CESM1-1-CAM5-CMIP5" "IPSL-CM6A-LR" "MIROC6" "CNRM-ESM2-1" "FGOALS-f3-L" "MPI-ESM1-2-LR" "MRI-ESM2-0")

# nodes for downloading from ESGF
# corresponding to the models above
ESGF_nodes=("noresg.nird.sigma2.no" "esg-dn1.nsc.liu.se" "esgf-data.ucar.edu" "vesg.ipsl.upmc.fr" "esgf-data02.diasjp.net" "esg1.umr-cnrm.fr" "esg.lasg.ac.cn" "esgf.dwd.de" "esgf-data03.diasjp.net")