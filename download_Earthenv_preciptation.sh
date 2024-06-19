#!/bin/bash
########################################################
# To download Earthenv (chelsa) precipitation daily data
########################################################

for yy in $(seq 2016 2016) ; do       ## Years
echo $yy
echo "Working for the year:" $yy
echo "-----------------"

        for i in $(seq -w 01 12) ; do  ## Months

                echo "Working for the month:" $i
                echo "====================="
wget --no-check-certificate https://data.earthenv.org/precipitation/CHELSA_preccor_land_${i}_${yy}.zip >&$yy_$i12.log&
        done

done
