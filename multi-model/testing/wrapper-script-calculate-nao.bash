#!/bin/bash

# wrapper script which makes the calls to the other scripts
# to generate the NAO anomaly for the multi-model ensemble

# wrapper-script-calculate-nao.bash
#
# Usage: wrapper-script-calculate-nao.bash <model> <start-year> <finish-year>
#
# For example: wrapper-script-calculate-nao.bash BCC-CSM2-MR 1961 2014

USAGE_MESSAGE="Usage: wrapper-script-calculate-nao.bash <model> <start-year> <finish-year>"

# check that the correct number of arguments have been passed
if [ $# -ne 3 ]; then
    echo "$USAGE_MESSAGE"
    exit 1
fi

# extract the model, start year and finish year
model=$1
start_year=$2
finish_year=$3

# extract the scripts to be run
scripts-directory=/home/users/benhutch/multi-model/

# process scripts
# don't think these are needed
# select-gridbox=${scripts-directory}/multi-model.sel-grid-boxes.bash
# select-2-9-DJFM=${scripts-directory}/multi-model.year-2-9-DJFM.bash
# calc-MM-state=${scripts-directory}/multi-model.calc-bl.bash
# calc-anomalies=${scripts-directory}/multi-model.sub_MM.bash
# combine-anomalies=${scripts-directory}/multi-model.combine_anom.bash
# time-mean=${scripts-directory}/multi-model.time-mean.bash
# mergetime=${scripts-directory}/multi-model.mergetime.bash
# calc-nao=${scripts-directory}/multi-model.NAO-anom.bash

# submit scripts
submit-select-gridbox=${scripts-directory}/submit-all-multi-model.bash
submit-select-2-9-DJFM=${scripts-directory}/submit-all-multi-model.year-2-9-DJFM.bash
submit-calc-MM-state=${scripts-directory}/submit-all-multi-model.calc-bl.bash
submit-calc-anomalies=${scripts-directory}/submit-all-multi-model.sub_MM.bash
submit-combine-anomalies=${scripts-directory}/submit-all-multi-model.combine_anom.bash
submit-time-mean=${scripts-directory}/submit-all-multi-model.time-mean.bash
submit-mergetime=${scripts-directory}/submit-all-multi-model.mergetime.bash
submit-calc-nao=${scripts-directory}/submit-all-multi-model.NAO-anom.bash

# call the scripts for both iceland and azores
# select the gridboxes
${submit-select-gridbox azores} $start_year $finish_year $model
${submit-select-gridbox iceland} $start_year $finish_year $model

# select the years 2-9 and DJFM
${submit-select-2-9-DJFM} azores $model
${submit-select-2-9-DJFM} iceland $model

# calculate the multi-model state
${submit-calc-MM-state} azores $model
${submit-calc-MM-state} iceland $model

# calculate the anomalies
${submit-calc-anomalies} azores $model $start_year $finish_year
${submit-calc-anomalies} iceland $model $start_year $finish_year

# combine the anomalies
${submit-combine-anomalies} azores $model $start_year $finish_year
${submit-combine-anomalies} iceland $model $start_year $finish_year

# time mean the anomalies
${submit-time-mean} azores $model $start_year $finish_year
${submit-time-mean} iceland $model $start_year $finish_year

# merge the time
${submit-mergetime} azores $model
${submit-mergetime} iceland $model

# calculate the NAO anomaly
${submit-calc-nao} $model








