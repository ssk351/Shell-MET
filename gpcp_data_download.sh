#!/bin/bash
## To download the GPCP data

for ((ii=2000; ii<=2022; ii++)) do

    for ((dd=1; dd<=31; dd++)) do
        if (($dd <= 9)); then
   wget "https://www.ncei.noaa.gov/data/global-precipitation-climatology-project\
-\
gpcp-daily/access/"${ii}"/gpcp_v01r03_daily_d"${ii}"010"${dd}"_c20170530.nc"
        else
   wget "https://www.ncei.noaa.gov/data/global-precipitation-climatology-project\
-\
gpcp-daily/access/"${ii}"/gpcp_v01r03_daily_d"${ii}"01"${dd}"_c20170530.nc"

        fi
    done

done
** note :from 2017 we need to modify "20170530","20171211"
https://www.ncei.noaa.gov/data/global-precipitation-climatology-project-gpcp-daily/access/2017/gpcp_v01r03_daily_d20170101_c20171211.nc
