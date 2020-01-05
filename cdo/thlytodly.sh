#!/bin/bash
# this script converts the 3hly files into daily files
for i in {2014..2014} ;do
cdo mergetime *$i*.nc merge_$i.nc
cdo -daysum -mulc,3 merge_$i.nc daily_$i.nc
rm merge_$i.nc
done
