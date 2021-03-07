#!/bin/bash
# To convert data from grd to netcdf
#x=("01072019" "01082019" "02072019" "02082019" "02092019" "03072019" "03082019" "03092019" "04082019" "04092019" "05092019" "25072019" "26072019" "27062019" "27072019" "28062019" "28072019" "29062019" "30062019"
#  )
x=("05082019")

for i in "${x[@]}";do
    echo "working with:"$i.grd
cat >test_${i}.ctl <<EOF
    DSET $i.grd
    TITLE 0.25 degranalyzed normal grids
    UNDEF -999.0
    XDEF  241  LINEAR  50.0 0.25
    YDEF  281  LINEAR  -30.0 0.25
    ZDEF   1 linear 1 1
    * CHANGE TDEF TO 366 FOR LEAP YEARS
    TDEF 1 LINEAR 28jun2019 1DY
    VARS  1
    rf 0 99 GRIDDED RAINFALL
    ENDVARS
EOF
 cdo -f nc import_binary test_${i}.ctl ${i}.nc
 rm test_${i}.ctl
done


