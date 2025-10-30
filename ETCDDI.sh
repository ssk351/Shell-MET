#!/bin/bash

#--- calc ECCDI climate indices from era5
#--- exclude indices that require a reference period
 
#--- get mean, min and max temp from hourly data
cdo shifttime,-1hour t2m_hourly_1950_2019.nc shift.nc 
cdo daymean shift.nc t2m_daymean_1950_2019.nc 
cdo daymin shift.nc t2m_daymin_1950_2019.nc
cdo daymax shift.nc t2m_daymax_1950_2019.nc

#--- positive degree day calc requires temp in celcius, the other indcies 
#--- use K.
cdo addc,-273.15 t2m_daymean_1950_2019.nc temp.nc
cdo chunit,'degK','degC' temp.nc t2m_daymean_celcius_1950_2019.nc 
    
#---convert precip unit m to mm. The rain indcies require units in mm 
cdo aexpr,"tp=tp*1000" tp_daysum_1950_2019.nc temp.nc
          
#--- rename the units 
cdo chunit,'m','mm' temp.nc tp_daysum_mm_1950_2019.nc 
          
#--- number of summer days, input: max temp
for yr in {1950..2019}
  do
  
    cdo -eca_fd -selyear,${yr} t2m_daymin_1950_2019.nc temp.nc
    ncpdq -a '-latitude' temp.nc fd_${yr}.nc 
    echo "calculating frost days from daily min temp"   

    cdo -eca_su -selyear,${yr} t2m_daymax_1950_2019.nc temp.nc
    ncpdq -a '-latitude' temp.nc su_${yr}.nc 
    echo "calculating summer days from daily max temp" 

    cdo -eca_id -selyear,${yr} t2m_daymax_1950_2019.nc temp.nc
    ncpdq -a '-latitude' temp.nc id_${yr}.nc 
    echo "calculating ice days from daily max temp" 
    
    cdo -eca_tr -selyear,${yr} t2m_daymin_1950_2019.nc temp.nc
    ncpdq -a '-latitude' temp.nc tr_${yr}.nc 
    echo "calculating tropical nights days from daily min temp" 
    
    #--- leave the growing season eca_gsl it needs a land-sea mask file
    #cdo -monmean -selyear,1950 t2m_daymax_1950_2019.nc temp.nc
    
    # outputs monthly -------------------------------------------------
    #--- do temp indices min-min
    cdo monmin -selyear,${yr} t2m_daymin_1950_2019.nc temp.nc
    cdo addc,-273.15 temp.nc temp_celcius.nc
    cdo chunit,'degK','degC' temp_celcius.nc temp.nc 
    ncpdq -a '-latitude' temp.nc tn_n_${yr}.nc 
    echo "calculating mon min temp from daily min temp" 
    
    #--- max-max
    cdo monmax -selyear,${yr} t2m_daymax_1950_2019.nc temp.nc
    cdo addc,-273.15 temp.nc temp_celcius.nc
    cdo chunit,'degK','degC' temp_celcius.nc temp.nc 
    ncpdq -a '-latitude' temp.nc tx_x_${yr}.nc 
    echo "calculating mon max temp from daily max temp" 
   
    #--- min-max
    cdo monmin -selyear,${yr} t2m_daymax_1950_2019.nc temp.nc
    cdo addc,-273.15 temp.nc temp_celcius.nc
    cdo chunit,'degK','degC' temp_celcius.nc temp.nc 
    ncpdq -a '-latitude' temp.nc tn_x_${yr}.nc 
    echo "calculating mon min temp from daily max temp" 
   
    #--- max-min
    cdo monmax -selyear,${yr} t2m_daymin_1950_2019.nc temp.nc
    cdo addc,-273.15 temp.nc temp_celcius.nc
    cdo chunit,'degK','degC' temp_celcius.nc temp.nc 
    ncpdq -a '-latitude' temp.nc tx_n_${yr}.nc 
    echo "calculating mon max temp from daily min temp" 
   #--------- end outputs monthly ----------------------------------
  
  
    cdo eca_rx1day -selyear,${yr} tp_daysum_mm_1950_2019.nc temp.nc
    ncpdq -a '-latitude' temp.nc rx1day_${yr}.nc 
    echo "Highest one day precipitation amount per time period from daily total precip (mm)"
    
    cdo eca_rx5day -selyear,${yr} tp_daysum_mm_1950_2019.nc temp.nc
    ncpdq -a '-latitude' temp.nc rx5day_${yr}.nc 
    echo "Highest five day precipitation amount per time period from daily total precip (mm)"
    
    cdo eca_sdii -selyear,${yr} tp_daysum_mm_1950_2019.nc temp.nc
    ncpdq -a '-latitude' temp.nc sdii_${yr}.nc 
    echo "Simple daily intensity index per time period from daily total precip (mm)"
    
    cdo eca_r10mm -selyear,${yr} tp_daysum_mm_1950_2019.nc temp.nc
    ncpdq -a '-latitude' temp.nc r10mm_${yr}.nc 
    echo "Heavy precip days > 10mm"
    
    cdo eca_r20mm -selyear,${yr} tp_daysum_mm_1950_2019.nc temp.nc
    ncpdq -a '-latitude' temp.nc r20mm_${yr}.nc 
    echo "Very heavy precip days > 20mm"
    
    cdo eca_cdd -selyear,${yr} tp_daysum_mm_1950_2019.nc temp.nc
    ncpdq -a '-latitude' temp.nc cdd_${yr}.nc 
    echo "Consecutive dry days default, 1mm threshold but can change this"
    
    cdo eca_cwd -selyear,${yr} tp_daysum_mm_1950_2019.nc temp.nc
    ncpdq -a '-latitude' temp.nc cwd_${yr}.nc 
    echo "Consecutive wet days default, 1mm threshold but can change this"
    
    cdo eca_rr1 -selyear,${yr} tp_daysum_mm_1950_2019.nc temp.nc
    ncpdq -a '-latitude' temp.nc rr1_${yr}.nc 
    echo "We days index default, 1mm threshold but can change this"
    
    #---postive degree days. This is not an eccdi index but useful. Input units oK
    #--- threshold units oC    
    cdo -O timsum -subc,0 -mul -selyear,${yr} t2m_daymean_celcius_1950_2019.nc -gtc,0 t2m_daymean_celcius_1950_2019.nc temp.nc 
    ncpdq -O -a '-latitude' temp.nc temp1.nc  
    cdo chname,'t2m','pdd' temp1.nc pdd_${yr}.nc 
    echo "Positive degree days"
    
    #--- calc annual sum of snowfall. Also not an eccdi indices but useful. 
    cdo yearsum -selyear,1950 sf_daysum_1950_2019.nc temp.nc
    
done
