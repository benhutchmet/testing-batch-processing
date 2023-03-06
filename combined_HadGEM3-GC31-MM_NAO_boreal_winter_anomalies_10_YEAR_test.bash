# TEST FILE FOR HADgem3 - TEST WITH 10 YEARS OF DATA

# combined sequence of bash loops to calculate the boreal winter NAO anomalies for HadGEM3-GC31-MM

# first select the gridboxes and the months required for boreal winter (DJFM)

# write a bash file to select the latitude and longitude for the azores and iceland boxes from JASMIN
# this is for all HadGEM3-GC31-MM initialization years and runs


# for the azores gridbox

for y in {1960..1970} # for each of the ensemble members - 	10 YEARS FOR TEST
do
	y_sd=$(( $y + 1 )) # the start date for years 2-9 (december of 1961 for 1960 initialization)
		for r in {1..10} # the iterations of the ensemble members
		do
			for n in {0..8} # iterations of the start times (Dec 1961 to March 1969 for 1960 initialization)
			do
			
				j=$(( $y_sd + $n)) # years of the boreal winter dates 2-9 (1961-69) 
				echo "start year ${j}"
				
				# select December of each year
				# MAKE SURE THE FOLDER YOU ARE SENDING THE FILES INTO IS CORRECT AND IDENTICAL
				cdo -sellonlatbox,-28,-20,36,40 -selmon,12 /badc/cmip6/data/CMIP6/DCPP/MOHC/HadGEM3-GC31-MM/dcppA-hindcast/s${y}-r${r}i1p1f2/Amon/psl/gn/files/d20200417/*${j}01-${j}12.nc /home/users/benhutch/HadGEM3-GC31-MM-JASMIN-10yr-TEST/psl_Amon_HadGEM3-GC31-MM_dcppA-hindcast_s${y}-r${r}i1p1f2_gn_${j}12_azores.nc
				
				# select January, Feb and March of each year
				# MAKE SURE THE FOLDER YOU ARE SENDING THE FILES INTO IS CORRECT AND IDENTICAL
				cdo -sellonlatbox,-28,-20,36,40 -selmon,1,2,3 /badc/cmip6/data/CMIP6/DCPP/MOHC/HadGEM3-GC31-MM/dcppA-hindcast/s${y}-r${r}i1p1f2/Amon/psl/gn/files/d20200417/*${j}01-${j}12.nc /home/users/benhutch/HadGEM3-GC31-MM-JASMIN-10yr-TEST/psl_Amon_HadGEM3-GC31-MM_dcppA-hindcast_s${y}-r${r}i1p1f2_gn_${j}01-${j}03_azores.nc
				
				echo "December and JFM files created for the azores gridbox, for initialization year ${y}, ensemble member ${r} and start year ${j}"
			done
		done
done


# for the iceland gridbox

for y in {1960..1970} # for each of the ensemble members - 10 YEARS FOR TEST
do
	y_sd=$(( $y + 1 )) # the start date for years 2-9 (december of 1961 for 1960 initialization)
		for r in {1..10} # the iterations of the ensemble members
		do
			for n in {0..8} # iterations of the start times (Dec 1961 to March 1969 for 1960 initialization)
			do
			
				j=$(( $y_sd + $n)) # years of the boreal winter dates 2-9 (1961-69) 
				echo "start year ${j}"
				
				# select December of each year
				# MAKE SURE THE FOLDER YOU ARE SENDING THE FILES INTO IS CORRECT AND IDENTICAL
				cdo -sellonlatbox,-25,-16,63,70 -selmon,12 /badc/cmip6/data/CMIP6/DCPP/MOHC/HadGEM3-GC31-MM/dcppA-hindcast/s${y}-r${r}i1p1f2/Amon/psl/gn/files/d20200417/*${j}01-${j}12.nc /home/users/benhutch/HadGEM3-GC31-MM-JASMIN-10yr-TEST/psl_Amon_HadGEM3-GC31-MM_dcppA-hindcast_s${y}-r${r}i1p1f2_gn_${j}12_iceland.nc
				
				# select January, Feb and March of each year
				# MAKE SURE THE FOLDER YOU ARE SENDING THE FILES INTO IS CORRECT AND IDENTICAL
				cdo -sellonlatbox,-25,-16,63,70 -selmon,1,2,3 /badc/cmip6/data/CMIP6/DCPP/MOHC/HadGEM3-GC31-MM/dcppA-hindcast/s${y}-r${r}i1p1f2/Amon/psl/gn/files/d20200417/*${j}01-${j}12.nc /home/users/benhutch/HadGEM3-GC31-MM-JASMIN-10yr-TEST/psl_Amon_HadGEM3-GC31-MM_dcppA-hindcast_s${y}-r${r}i1p1f2_gn_${j}01-${j}03_iceland.nc
				
				echo "December and JFM files created for the azores gridbox, for initialization year ${y}, ensemble member ${r} and start year ${j}"
			done
		done
done

# ALL FINE UP TO HERE

# merge the D and JFM data from consecutive years together

# for this all years of the azores and iceland data must be in the same folder


arr=( "azores" "iceland" ) # for the two grid boxes which define the NAO

for k in "${arr[@]}"
do 
	for y in {1960..1970} # the initialization start dates for the hindcast runs - 10 YEARS FOR TEST
	do
		y_sd=$(( $y + 1 )) # the second year winter (December) for each of the hindcast runs
			for r in {1..10} # the iterations of the ensemble members (10 members)
			do
				for n in {0..7} # the iterations of the start times for december datasets
				do 
					j=$(( $y_sd + $n)) # the years of the december boreal winter start dates dates (2-9)
					
					i=$(( $j + 1 )) # the year following the december which will contain Jan/Feb/March
					
					cdo mergetime psl_Amon_HadGEM3-GC31-MM_dcppA-hindcast_s${y}-r${r}i1p1f2_gn_${j}12_${k}.nc psl_Amon_HadGEM3-GC31-MM_dcppA-hindcast_s${y}-r${r}i1p1f2_gn_${i}01-${i}03_${k}.nc psl_Amon_HadGEM3-GC31-MM_dcppA-hindcast_s${y}-r${r}i1p1f2_gn_${j}12-${i}03_${k}.nc
					
					
					echo "initialization year ${y}, ensemble member ${r}, December ${j}, Jan/Feb/March ${i}, location ${k}"
				
				done 
			done
	done
done

# calculate the ensemble mean (baseline) for each of the ensemble members

# bash function to average over the ensemble members and all years toto create the baseline /
# for the full field of files from 1960-2018

# this assumes that all the iceland and azores data is in the same folder


arr=( "azores" "iceland" ) # for the two grid boxes which define the NAO

for k in "${arr[@]}"
do

	for r in {1..10} # for each of the ensemble members
	do
		cdo ensmean psl_Amon_HadGEM3-GC31-MM_dcppA-hindcast_s*-r${r}i1p1f2_gn_*12-*03_${k}.nc psl_Amon_HadGEM3-GC31-MM_dcppA-hindcast_r${r}i1p1f2_gn_196112-202703_ensmean_${k}.nc 
		echo "ensmean baseline created for ${k} gridbox for member ${r}"
	done


done 


# this loop will calculate the 8 year running mean boreal winter anomalies for each initialization date and each ensemble member
# for initialization in 1960, the 8yrRM is just the average of the hindcast from Dec 1961 to Mar 1969

arr=( "azores" "iceland" ) # for the two grid boxes which define the NAO

for k in "${arr[@]}"
do 

	for y in {1960..1970} # the years containing the start of the boreal winter for the initialization period from 1960 - 1968 # MODIFIED FOR TEST PERIOD 1960 - 1970
	do
		for r in {1..10} # calculate the 8-year running mean winter anomalies for the initialization dates - for each member
		do
			
			# calculate the ensemble means for each of the initialization dates for each of the members
			cdo ensmean *${y}-r${r}i1p1f2_gn_*12-*03_${k}.nc psl_Amon_HadGEM3-GC31-MM_dcppA-hindcast_s${y}-r${r}i1p1f2_gn_8yrRM_${k}.nc
			echo "8-year running mean calculated for initialization year ${y} in gridbox ${k} for member ${r}"
			
			
			# now perform the subtration of the 8-yr running mean from the baseline for this period for each of the ensemble members
			cdo sub psl_Amon_HadGEM3-GC31-MM_dcppA-hindcast_s${y}-r${r}i1p1f2_gn_8yrRM_${k}.nc psl_Amon_HadGEM3-GC31-MM_dcppA-hindcast_r${r}i1p1f2_gn_196112-202703_ensmean_${k}.nc psl_Amon_HadGEM3-GC31-MM_dcppA-hindcast_s${y}-r${r}i1p1f2_gn_8yrRM_anom_${k}.nc
			echo "file containing the anomalies relative to member ${r} baseline for initialization year ${y} and gridbox ${k}"
			
		done
	done
done

# bash loop will contain the code and loops to combine the initialization year data into one dataset for each of the initialization years

arr=( "azores" "iceland" ) # for the two grid boxes which define the NAO

for k in "${arr[@]}" # for the azores and iceland files
do

	for r in {1..10} # for each of the members
	do

		# merge the time files for all of the initialization dates
		cdo mergetime psl_Amon_HadGEM3-GC31-MM_dcppA-hindcast_s*-r${r}i1p1f2_gn_8yrRM_anom_${k}.nc psl_Amon_HadGEM3-GC31-MM_dcppA-hindcast_s1960-2018_r${r}i1p1f2_gn_8yrRM_anom_${k}.nc
		echo "full range psl anomaly dataset created for member ${r} in location ${k}"
	done 

done

# now calculate the NAO DJFM anomalies for each of the member runs

for r in {1..10} # needs to be done for each of the member runs
do
	# CDO ABORT - Grid size of the input parameter psl do not match!
	
	# azores - iceland
	cdo sub -fldmean psl_Amon_HadGEM3-GC31-MM_dcppA-hindcast_s1960-2018_r${r}i1p1f2_gn_8yrRM_anom_azores.nc -fldmean psl_Amon_HadGEM3-GC31-MM_dcppA-hindcast_s1960-2018_r${r}i1p1f2_gn_8yrRM_anom_iceland.nc psl_Amon_HadGEM3-GC31-MM_dcppA-hindcast_s1960-2018_r${r}i1p1f2_gn_8yrRM_NAO_anom.nc
	
	echo "NAO dataset created for member ${r}"

done

# now we should have 10 complete files which contain the NAO for each of the members
# finally calculate an ensemble mean of these

cdo ensmean psl_Amon_HadGEM3-GC31-MM_dcppA-hindcast_s1960-2018_r*i1p1f2_gn_8yrRM_NAO_anom.nc psl_Amon_HadGEM3-GC31-MM_dcppA-hindcast_s1960-2018_all_member_ensmean_gn_8yrRM_NAO_anom.nc
