#!bin/bash
# This script crop the inputfile over India
for i in *.nc ;do cdo remapbil,ref.nc $i ./ind_$i ;done
