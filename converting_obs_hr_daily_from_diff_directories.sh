##!/bin/bash
##------------------------------------------------------------------------
# Make sure U have modified the ipdir and opdir
# Load CDO and use Write time axis and merge the to write daily file
# Reading the Observation files from
# -Daily directories havaing the hourly files
##------------------------------------------------------------------------
#for y in `seq 2007 2018` ;do ##year=2000
    ipdir=/mnt/e/GESDISC_GPM/DD/miss
    echo $ipdir
    opdir=/mnt/e/GESDISC_GPM/DD/PDATA
    cd $ipdir
#----------------------------    
    for i in *.nc4 ;do
	filename=${i}
	echo "----------"
	echo "working with the file"
	echo $filename
	echo "----------"
	file="${filename##*_}"
	nd="${file//[!0-9]/}"
	echo $nd
	yy=${nd:0:4}
	mm=$(echo "$nd" | cut -c5,6)
	dd=$(echo "$nd" | cut -c7,8)
	HH=$(echo "$nd" | cut -c9,10)
	echo $yy$mm$dd
	cdo settunits,hours -settaxis,$yy"-"$mm"-"$dd,"00:00:00",h $i $opdir/$i
    done
#	cdo mergetime $opdir/Z_NAFP*.nc $opdir/$yy$mm$dd".nc"
#	rm $opdir/Z_NAFP*.nc
#----------------------------    

#done
