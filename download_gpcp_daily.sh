#!/bin/bash
## To download the GPCP data

for ((ii=1997; ii<=1997; ii++)) do

    for ((dd=1; dd<=3; dd++)) do
	if (($dd <= 9)); then	
   wget "https://www.ncei.noaa.gov/data/global-precipitation-climatology-project-gpcp-daily/access/"${ii}"/gpcp_v01r03_daily_d"${ii}"010"${dd}"_c20170530.nc"
	else
   wget "https://www.ncei.noaa.gov/data/global-precipitation-climatology-project-gpcp-daily/access/"${ii}"/gpcp_v01r03_daily_d"${ii}"01"${dd}"_c20170530.nc"	

	fi
    done


done
