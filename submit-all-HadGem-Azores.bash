# Submit all of the jobs to the batch cluster

#!/bin/bash

# submit-all-HadGEM.bash
#
# Usage:    submit-all-HadGEM.bash
#

# set the partition/account arguments for LOTUS based on usage context
# SBATCH --partition=short-serial

EXTRACTOR=$PWD/HadGEM_sellonlat_test.bash
OUTPUTS_DIR=/home/users/benhutch/batch-testing/lotus-outputs

# make the output directory if it doesn't exist
mkdir -p $OUTPUTS_DIR

# set the partition arguments
sbatch_part_cmds="--partition=short-serial"

# set the lon/lat values for the azores
lon1=-28
lon2=-20
lat1=36
lat2=40

# set the location
location=azores

# loop through the files and process them
# echo the location and the lon/lat values
echo "[INFO] Subsetting: $location"
echo "[INFO] Subsetting: $lon1, $lon2, $lat1, $lat2"

# submit the job to LOTUS
sbatch $sbatch_part_cmds -t 5 -o $OUTPUTS_DIR/${location}.%j.out \
       -e $OUTPUTS_DIR/${location}.%j.err $EXTRACTOR $lon1 $lon2 $lat1 $lat2 $location
