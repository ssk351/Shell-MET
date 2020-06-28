# Data download for CPC (Climate Prediction Center) data 
#!bin/bash
for i in {1979..2019..1};do
wget ftp://ftp.cdc.noaa.gov/Datasets/cpc_global_precip/precip.${i}.nc ;done
