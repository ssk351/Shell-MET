load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin
;
  fils = systemfunc ("ls /home/SSPMRES/hari/WRF/WRFV422/test/em_real_1994050100/CZD/wrfout_d01_1994-*") ; file paths
  a = addfiles(fils,"r")
  ListSetType (a, "cat")        		; concatenate (=default)
  XLAT = a[0]->XLAT(0,:,0) ; (south_north, west_east)
  XLAT@axis = "Y"
  XLAT@standard_name = "latitude"
  XLONG = a[0]->XLONG(0,0,:)
  XLONG@axis = "X"
  XLONGstandard_name = "longitude"

  times = wrf_user_getvar(a,"times",-1)  	; get all times in the file
  ntimes = dimsizes(times)         		; number of times in the file
  rainnc=a[:]->RAINNC
  rainc=a[:]->RAINC

  tend_int = 1
  rain_c=rainc;rain_c=0.0;rain=rain_c
  rain_c(tend_int:ntimes-1:tend_int,:,:) = rainc(tend_int:ntimes-1:tend_int,:,:) - rainc(0:ntimes-2:tend_int,:,:)
  rain_nc=rainc;rain_nc=0.0;
  rain_nc(tend_int:ntimes-1:tend_int,:,:) = rainnc(tend_int:ntimes-1:tend_int,:,:) - rainnc(0:ntimes-2:tend_int,:,:)
  rain=rain_c+rain_nc
  copy_VarCoords(rainc,rain)
  rain!0 = "Time"
  rain&Time = ispan(0,ntimes-1,1)
  rain&Time@units= "days since 1994-06-01 00:00:00"
  rain&Time@axis= "T"
  rain&Time@standard_name = "time"
  rain!1 = "lat"
  rain&lat = XLAT
  rain!2 = "lon"
  rain&lon = XLONG
  rain@long_name = "Total Rainfall"
  rain@units = "mm/day"
  rain@coordinates = "XLONG XLAT XTIME"


system("rm -f WRF_1994.nc") 
ncdf_KF = addfile("WRF_1994.nc" ,"c") 
ncdf_KF->rainfall = rain  

end 
