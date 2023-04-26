#!/bin/bash
#
# multi-file-mergetime-test.bash
#
# For example: multi-file-mergetime-test.bash HadGEM3-GC31-MM 1960 1 1
#

USAGE_MESSAGE="Usage: multi-file-mergetime-test.bash <model> <initialization-year> <run-number> <initialization-number>"

# check that the correct number of arguments have been passed
if [ $# -ne 4 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# set the model and initialization year
model=$1
init_year=$2

# set the run number and initialization number
run=$3
init=$4

# set the output directory
OUTPUT_DIR=/work/scratch-nopw/benhutch/$model/outputs/mergetime
# make the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# set up an if loop for the model name
if [ $model == "HadGEM3-GC31-MM" ]; then
    # set the files to be processed
    model_group="MOHC"
elif [ $model == "EC-Earth3" ]; then
    # set the files to be processed
    model_group="EC-Earth-Consortium"
elif [ $model == "EC-Earth3-HR" ]; then
    # set the files to be processed
    model_group="EC-Earth-Consortium"
else 
    echo "[ERROR] Model name not recognised"
    exit 1
fi

# echo the model name and group
echo "Model: $model"
echo "Model group: $model_group"

# set up the files
# if the model is HadGEM3-GC31-MM or EC-Earth3
# then the files are in the format:
# /badc/cmip6/data/CMIP6/DCPP/$model_group/$model/dcppA-hindcast/s${init_year}-r${run}i${init}p?f?/Amon/psl/g?/files/d????????/*.nc
if [ $model == "HadGEM3-GC31-MM" ] || [ $model == "EC-Earth3" ]; then
    files="/badc/cmip6/data/CMIP6/DCPP/$model_group/$model/dcppA-hindcast/s${init_year}-r${run}i${init}p?f?/Amon/psl/g?/files/d????????/*.nc"
elif [ $model == "EC-Earth3-HR" ]; then
    files="/work/xfc/vol5/user_cache/benhutch/$model_group/$model/psl_Amon_${model}_dcppA-hindcast_s${init_year}-r${run}i${init}p?f?_g?_*.nc"
else
    echo "[ERROR] Model name not recognised"
    exit 1
fi


# test the files
# /work/xfc/vol5/user_cache/benhutch/EC-Earth-Consortium/EC-Earth3-HR/psl_Amon_EC-Earth3-HR_dcppA-hindcast_s1995-r5i2p?f?_g?_*.nc

# activate the environment containing CDO
module load jaspy

# set up the final year for the filename
if [ $model == "HadGEM3-GC31-MM" ] || [ $model == "EC-Earth3" ]; then
    final_year=$((init_year+11))
elif [ $model == "EC-Earth3-HR" ]; then
    final_year=$((init_year+5))
else
    echo "[ERROR] Model name not recognised"
    exit 1
fi

# set up the filename for the merged file
merged_fname="psl_Amon_${model}_dcppA-hindcast_s${init_year}-r${run}i${init}_gn_${init_year}11-${final_year}03.nc"
# set up the path for the merged file
merged_file="$OUTPUT_DIR/$merged_fname"

# merge the files into a single file
# by the time axis
echo "[INFO] Merging files by time axis for $model, s$init_year, r$run, i$init"
echo "[INFO] Files to be merged: $files"

# merge the files
cdo mergetime $files $merged_file

