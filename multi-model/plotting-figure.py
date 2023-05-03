# import the required modules
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import xarray as xr
from scipy.stats import pearsonr

# load the required dataset
# first load the observation data (ERA5)
obs = xr.open_dataset("/home/users/benhutch/ERA5_psl/nao-anomaly/nao-anomaly-ERA5.8yrRM.nc", chunks={"time": 10})

# load the model data for all models
# already pre-processed to multi-model mean
model = xr.open_dataset("/home/users/benhutch/multi-model/multi-model.mean-NAO.nc", chunks={"time": 10})

# extract the data for the observations
obs_psl = obs["var151"]
obs_time = obs_psl["time"].values
# set the type for the time variable
obs_time = obs_time.astype("datetime64[Y]")

# process the obs data from Pa to hPa
obs_nao_anom = obs_psl[:, 0, 0] / 100

# extract the data for the multi-model mean
model_psl = model["psl"]
model_time = model_psl["time"].values
# set the type for the time variable
model_time = model_time.astype("datetime64[Y]")

# process the model data from Pa to hPa
model_nao_anom = model_psl[:, 0, 0] / 100

# plot the evolution of the NAO index with time
# first create the figure
fig = plt.figure(figsize=(10, 6))
# add the axes
ax = fig.add_subplot(111)
# plot the data
# now aligned, but still looks very slightly off compared to Doug's plot and Andrea's plot
# perhaps something to ask doug down the line
ax.plot(obs_time[3:], obs_nao_anom[3:], color="black", label="ERA5")
ax.plot(model_time[:-4], model_nao_anom[:-4], color="red", label="DCPP-A")
ax.axhline(y=0, color="black", linestyle="-", linewidth=0.5)
# set the x-axis limits
ax.set_xlim([np.datetime64("1960"), np.datetime64("2020")])
# set the y-axis limits
ax.set_ylim([-10, 10])
# set the x-axis label
ax.set_xlabel("Reference Year")
# set the y-axis label
ax.set_ylabel("NAO (hPa )")
# set the title
ax.set_title("NAO anomalies, raw ensemble")
# add the legend in the bottom right corner
ax.legend(loc="lower right")
# save the figure
plt.savefig("/home/users/benhutch/multi-model/plots/nao-anomaly-raw.png", dpi=300)
# show the figure
plt.show()


# Calculate the ACC and p-value
ACC, p_value = pearsonr(obs_nao_anom[3:], model_nao_anom[:-4])
print("Anomaly Correlation Coefficient (ACC):", ACC)
print("P-value:", p_value)

# 