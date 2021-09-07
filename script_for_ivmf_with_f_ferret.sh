#!/bin/bash
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
##  load ferret
## use  module load ferret/7.6.0
    module load ferret/7.6.0
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

#:;;;;;;;;::::::::::::::::::
# To compute IVMT_DIVERGENCE
#:;;;;;;;;::::::::::::::::::
diri_ua=/home/SSPMRES/hari/WRF/CMIP6/UA_NEW
diri_va=/home/SSPMRES/hari/WRF/CMIP6/VA_NEW
diri_sph=/home/SSPMRES/hari/WRF/CMIP6/SPH/PROCESSED/
#out_diri=./  ##/home/SSPMRES/hari/WRF/CMIP6/IVMFC_NEW/
#models=('ACCESS-CM2' 'ACCESS-ESM1-5')

models=('ACCESS-CM2' 'ACCESS-ESM1-5' 'BCC-CSM2-MR' 'BCC-ESM1' 'CESM2-FV2' 'CESM2-WACCM-FV2' 'CESM2-WACCM' 'CESM2' 'CanESM5' 'EC-Earth3-Veg' 'EC-Earth3' 'FGOALS-g3' 'FIO-ESM-2-0' 'GFDL-ESM4' 'GISS-E2-1-G-CC' 'GISS-E2-1-G' 'GISS-E2-H' 'INM-CM4-8' 'INM-CM5-0' 'IPSL-CM6A-LR' 'MCM-UA-1-0' 'MIROC6' 'MPI-ESM-1-2-HAM' 'MPI-ESM1-2-HR' 'MPI-ESM1-2-LR' 'MRI-ESM2-0' 'NorESM1' 'NorESM2-LM' 'NorESM2-MM' 'SAMO-UNION' 'TaiESM1')
for i in "${!models[@]}"; do
   aa=$diri_ua/ua_Amon_${models[i]}_historical_r1i1p1f1_gn_190001-201412_new.nc
   bb=$diri_va/va_Amon_${models[i]}_historical_r1i1p1f1_190001-201412.nc
    cc=$diri_sph${models[i]}_historical_r1i1p1f1_gn_190001-201412.nc
    dd=${models[i]}_historical_r1i1p1f1_IVMFC_1901_2014.nc ##output

echo "   "

echo "-------working with the following files-------"

echo "   "
echo $aa
echo $bb
echo $cc

cat > test_${models[i]}.jnl <<EOF

can da/all
can var/all
set mem/size=1500
!------------------------Observation--------------------------------------------------------------------
use $aa
use $bb
use $cc
show data

!-------------- compute qu qv---------------------------
let qu = hus[d=3,z=30000:100000]*ua[d=1,z=30000:100000] 
let qv = hus[d=3,z=30000:100000]*va[d=2,z=30000:100000]

!-------------VIMF (transport) calculation-------------------
let Ucomp = qu[z=30000:100000@din]*(1/9.81)*100
let Vcomp = qv[z=30000:100000@din]*(1/9.81)*100            ! ucomp and vcomp have unit kg/m/s

!----------divergence calculation---------------------------
let dqu_dx  = qu[x=@ddc]
let dqv_dy  = qv[y=@ddc]
let A  = dqu_dx+dqv_dy
let div = A[z=30000:100000@din]*(1/9.81)*100
let mdiv = (div*86400)                            ! moisture divergence conversion into mm/day

!------------for saving the variable--------------------------------------------------------
repeat/l=1:1368 (save/llimits=1:1368:1/file=$dd/append Ucomp,Vcomp,mdiv; set mem/size=2000)     !! 1380 are timesteps
           !OR

!set mem/size=2000
!save/file =  vimf_noaa20crv2_1901_2014.nc Ucomp,Vcomp,mdiv
!--------------------------------------------------------------------------------------------------------

EOF
ferret -script test_${models[i]}.jnl 
ulimit -s unlimited
ulimit -c unlimited
done

