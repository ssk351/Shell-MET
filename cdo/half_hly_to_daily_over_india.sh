#!/bin/bash                                                                                                                                                              
#;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                                                                                         
# This script to convert 1/2 hly files into daily with remapping to IMD griddes                                                                                          
# ; 1 . create directory                                                                                                                                                 
# ; 2 . Remapping the files                                                                                                                                              
# ; 3 . Merging                                                                                                                                                          
# ; 4 . To Daily                                                                                                                                                         
#;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                                                                                         

for j in {2014..2014..01}    # can edit ur YRSTART and YREND                                                                                                             

do
      mkdir gpm_${j}  # creating new directory                                                                                                                         

      for i in *${j}*.nc

         do

        
        cdo remapbil,grides.txt ${i} ./gpm_${j}/${i}   # Remapping the each file                                                                                         

        cd gpm_${j}/

        ncrcat GPM_IMERG_2014*.nc gpm_monsoon_${j}.nc   # merging the data file                                                                                          

        cdo daysum gpm_monsoon_${j}.nc gpm_monsoon_${j}_daily.nc  # converting to daily 
        
        cd ../

          done
done

