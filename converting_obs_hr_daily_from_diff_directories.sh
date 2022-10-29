##!/bin/bash
##------------------------------------------------------------------------
# Make sure U have modified the ipdir and opdir
# Load CDO and use Write time axis and merge the to write daily file
# Reading the Observation files from
# -Daily directories havaing the hourly files
# 
##------------------------------------------------------------------------
year=2021
for j in {01..12..01} ; do ## months
    ipdir=/mnt/d/$year$j
    echo $ipdir
    opdir=/mnt/d/DELE
    cd $ipdir
#----------------------------    
    for i in *.nc ;do
	filename=${i}
	echo "----------"
	echo "working with the file"
	echo $filename
	echo "----------"
	file="${filename##*_}"
	nd="${file//[!0-9]/}"
	yy=${nd:0:4}
	mm=$(echo "$nd" | cut -c5,6)
	dd=$(echo "$nd" | cut -c7,8)
	HH=$(echo "$nd" | cut -c9,10)
	echo $yy$mm$dd$HH
	cdo settunits,hours settaxis,$yy"-"$mm"-"$dd,$HH":00:00",h $i $opdir/$i
	cdo mergetime $opdir/Z_NAFP*.nc $opdir/$yy$mm$dd".nc"
	rm $opdir/Z_NAFP*.nc
    done
#----------------------------    
done

