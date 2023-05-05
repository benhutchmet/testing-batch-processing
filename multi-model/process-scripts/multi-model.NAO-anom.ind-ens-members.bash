#!/bin/bash

# multi-model.NAO-anom.ind-ens-members.bash
#
# Usage: multi-model.NAO-anom.ind-ens-members.bash <model> <run> <init> <lag>
#
# For example: multi-model.NAO-anom.bash BCC-CSM2-MR 1 1 lag
USAGE_MESSAGE="Usage: multi-model.NAO-anom.bash <model> <run> <init> <lag>"

# check that the correct number of arguments have been passed
if [ $# -ne 4 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# set the model run and init
model=$1
run=$2
init=$3
lag=$4

# set the output directory
OUTPUT_DIR=/work/scratch-nopw/benhutch/$model/nao-anomaly/ind-members/
# make the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# set the files to be processed
# in the nolag case
if [ $lag == "nolag" ]; then
    azores=/work/scratch-nopw/benhutch/$model/azores/outputs/ind-members/mergetime/merged-time-mean-years-2-9-DJFM-anomalies-azores-psl_Amon_dcppA-hindcast-${model}_r${run}i${init}-${lag}.nc
    iceland=/work/scratch-nopw/benhutch/$model/iceland/outputs/ind-members/mergetime/merged-time-mean-years-2-9-DJFM-anomalies-iceland-psl_Amon_dcppA-hindcast-${model}_r${run}i${init}-${lag}.nc
# in the lag case
elif [ $lag == "lag" ]; then
    azores=/work/scratch-nopw/benhutch/$model/azores/outputs/ind-members/mergetime/merged-time-mean-years-2-9-DJFM-anomalies-azores-psl_Amon_dcppA-hindcast-${model}_r${run}i${init}-${lag}.nc
    iceland=/work/scratch-nopw/benhutch/$model/iceland/outputs/ind-members/mergetime/merged-time-mean-years-2-9-DJFM-anomalies-iceland-psl_Amon_dcppA-hindcast-${model}_r${run}i${init}-${lag}.nc
fi                    





# echo the files being processed
echo "azores file: $azores"
echo "iceland file: $iceland"

# activate the environment containing CDO
module load jaspy

# calculate the NAO anomaly
cdo sub -fldmean $azores -fldmean $iceland $OUTPUT_DIR/nao-anomaly-${model}_r${run}i${init}-${lag}.nc