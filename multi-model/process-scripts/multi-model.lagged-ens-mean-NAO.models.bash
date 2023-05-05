#!/bin/bash

# script to calculate the multi-model ensemble mean
# for the lag ensemble models
#
# Usage: multi-model.lag-ensemble-mean.bash

#!/bin/bash
# import the updated models list
source $PWD/models.bash
echo "[INFO] Models list: $models"

# Set the path to the base directory containing the model directories
BASE_DIR="/work/scratch-nopw/benhutch"

# Create output directory if it doesn't exist
OUTPUT_DIR="$BASE_DIR/ensemble_means"
mkdir -p $OUTPUT_DIR

# Initialize the multi-model ensemble mean command
mm_ensemble_mean_cmd="cdo ensmean"

# Loop through the models to calculate the ensemble mean for each model
for model in $models; do
  # echo the current model
  echo "[INFO] Current model: $model"

  model_dir="$BASE_DIR/$model/nao-anomaly/ind-members"
  model_output="$OUTPUT_DIR/nao-anomaly-${model}-ensemble-mean.nc"

  # Get all the files for the current model
  model_files=$(ls "${model_dir}"/*.nc)

  # Calculate the ensemble mean for the current model
  cdo ensmean $model_files $model_output

  # Add the current model's ensemble mean file to the multi-model ensemble mean command
  mm_ensemble_mean_cmd+=" $model_output"
done

# Calculate the multi-model ensemble mean
mm_ensemble_mean_output="$OUTPUT_DIR/nao-anomaly-multi-model-ensemble-mean.nc"
$mm_ensemble_mean_cmd $mm_ensemble_mean_output

echo "Ensemble means calculated and saved in $OUTPUT_DIR"
