#####################################
## Chirps data download
## Data spatial and Temporal Resolution - 0.05 deg and Monthly
#####################################
for yy in {1981..2023..1};
do
    wget https://edcintl.cr.usgs.gov/downloads/sciweb1/shared/fews/web/global/monthly/chirps/final/downloads/yearly/${yy}.zip;
done

