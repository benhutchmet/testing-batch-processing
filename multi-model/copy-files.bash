#!/bin/bash

# Target directory
target_dir="/home/users/benhutch/multi-model/ind-members"

# List of folders to copy files into
folders=("BCC-CSM2-MR" "CMCC-CM2-SR5" "HadGEM3-GC31-MM" "MPI-ESM1-2-HR" "CanESM5" "EC-Earth3" "IPSL-CM6A-LR" "MPI-ESM1-2-LR" "CESM1-1-CAM5-CMIP5" "FGOALS-f3-L" "MIROC6" "NorCPM1")

# Iterate through folders
for folder in "${folders[@]}"; do
  # echo folder name
  echo "[INFO] Copying files for model: ${folder}"

  # Source directory
  source_dir="/work/scratch-nopw/benhutch/${folder}/nao-anomaly/ind-members"

  # Create target folder if it doesn't exist
  mkdir -p "${target_dir}/${folder}"

  # Copy files from source to target
  cp "${source_dir}/nao-anomaly-${folder}_r"*"-nolag.nc" "${target_dir}/${folder}"
done
