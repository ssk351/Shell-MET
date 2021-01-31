#!/bin/bash
#;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
# converting IMDAA Rainfall data into yearly data set
# in CDO (mergetime,chname)
# Req 12 files per year
#;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
###
mkdir RF
for year in `seq 1982 1982`;do
    echo "working with:" $year
    cdo mergetime *$year*.nc ./RF/$m_{year}.nc
    cdo chname,APCP-sfc,rf *$year*.nc ./${year}.nc
    rm m*.nc
done
