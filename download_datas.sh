for i in `seq 1981 2021` ;do

wget --no-check-certificate https://downloads.psl.noaa.gov/Datasets/noaa.oisst.\
v2.highres/sst.day.mean.$i.nc

done
