#!/bin/bash

# models.bash
# file containing the list of models to be processed

# list of models
# available on JASMIN
models="BCC-CSM2-MR MPI-ESM1-2-HR CanESM5 CMCC-CM2-SR5 HadGEM3-GC31-MM EC-Earth3"

single_file_models="BCC-CSM2-MR MPI-ESM1-2-HR CanESM5 CMCC-CM2-SR5"

multi_file_models="HadGEM3-GC31-MM EC-Earth3"

# models downloaded from CEDA/LLNL ESGF server to xfer
# NorCPM1
# EC-Earth3-HR
# CESM1-1-CAM5-CMIP5
# IPSL-CM6A-LR
# MIROC6
# CNRM-ESM2-1
# FGOALS-fs-L
# MPI-ESM1-2-LR
# MRI-ESM2-0

# corresponding nodes
# noresg.nird.sigma2.no
# esg-dn1.nsc.liu.se
# esgf-data.ucar.edu
# vesg.ipsl.upmc.fr
# esgf-data02.diasjp.net
# esg1.umr-cnrm.fr
# esg.lasg.ac.cn
# esgf.dwd.de
# esgf-data03.diasjp.net 

# format these as arrays
ESGF_models=("NorCPM1" "EC-Earth3-HR" "CESM1-1-CAM5-CMIP5" "IPSL-CM6A-LR" "MIROC6" "CNRM-ESM2-1" "FGOALS-f3-L" "MPI-ESM1-2-LR" "MRI-ESM2-0")

ESGF_nodes=("noresg.nird.sigma2.no" "esg-dn1.nsc.liu.se" "esgf-data.ucar.edu" "vesg.ipsl.upmc.fr" "esgf-data02.diasjp.net" "esg1.umr-cnrm.fr" "esg.lasg.ac.cn" "esgf.dwd.de" "esgf-data03.diasjp.net")