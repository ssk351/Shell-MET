#!/bin/bash

for line1 in `ls -l | awk 'NR!=1 && /^d/ {print $NF}'` # get list of all directories
do
cd $line1
echo $line1
echo "Entering into directory...............> $line1"


cat >target << EOF
#gridtype  = generic

gridtype  = latlon
gridsize  = 49950
xname     = lon
xlongname = longitude
xunits    = degrees_east
yname     = lat
ylongname = latitude
yunits    = degrees_north
xsize     = 222
ysize     = 225
#levels    =4
xfirst    = 76.90467
xinc      = 0.02077
yfirst    = 27.96503
yinc      = 0.01835
EOF

######## Files loop started ##############

####mkdir -p LDAS_LHF LDAS_SHF ###LDAS_Evap

for i in *.LDASOUT_DOMAIN1
do
 IC=`echo $i | egrep -o '[[:digit:]]{10}'`
 echo "${IC}"
# date=`echo $i | cut -c1-10`
# name=`echo $i | cut -c12-18`
### cp target $line1
 cdo -r setgrid,target $i ${i}.nc

# cdo select,name=QFX ${i}.nc ${date}_${name}_4km_LHF.nc
# mv ${date}_${name}_4km_LHF.nc LDAS_LHF

# cdo select,name=HFX ${i}.nc ${date}_${name}_4km_SHF.nc
# mv ${date}_${name}_4km_SHF.nc LDAS_SHF

# cdo select,name=SFCEVP ${i}.nc ${date}_${name}_4km_Evap.nc
# mv ${date}_${name}_4km_Evap.nc LDAS_Evap

#rm -f $i
done

cd ..
done
echo "finished....Directories..Loop.."

