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
submit_select_gridbox=$PWD/submit-all-multi-model.bash
submit_select_2_9_DJFM=$PWD/submit-all-multi-model.year-2-9-DJFM.bash
submit_calc_MM_state=$PWD/submit-all-multi-model.calc-bl.bash
submit_calc_anomalies=$PWD/submit-all-multi-model.sub_MM.bash
submit_combine_anomalies=$PWD/submit-all-multi-model.combine_anom.bash
submit_time_mean=$PWD/submit-all-multi-model.time-mean.bash
submit_mergetime=$PWD/submit-all-multi-model.mergetime.bash
submit_calc_nao=$PWD/submit-all-multi-model.NAO-anom.bash

# call the scripts for both iceland and azores
# select the gridboxes
bash ${submit_select_gridbox} azores $start_year $finish_year $model
bash ${submit_select_gridbox} iceland $start_year $finish_year $model

# select the years 2_9 and DJFM
bash ${submit_select_2_9_DJFM} azores $model
bash ${submit_select_2_9_DJFM} iceland $model

# calculate the multi_model state
bash ${submit_calc_MM_state} azores $model
bash ${submit_calc_MM_state} iceland $model

# calculate the anomalies
bash ${submit_calc_anomalies} azores $model $start_year $finish_year
bash ${submit_calc_anomalies} iceland $model $start_year $finish_year

# combine the anomalies
bash ${submit_combine_anomalies} azores $model $start_year $finish_year
bash ${submit_combine_anomalies} iceland $model $start_year $finish_year

# time mean the anomalies
bash ${submit_time_mean} azores $model $start_year $finish_year
bash ${submit_time_mean} iceland $model $start_year $finish_year

# merge the time
bash ${submit_mergetime} azores $model
bash ${submit_mergetime} iceland $model

# calculate the NAO anomaly
bash ${submit_calc_nao} $model








