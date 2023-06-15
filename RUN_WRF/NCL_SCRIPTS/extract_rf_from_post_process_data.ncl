;##########################################
;;;;#Provide the dates of the evnet mm/dd
;##########################################
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
begin
  ; set the netcdf file global attributes
  fileAtt                = True
  fileAtt@creation_date  =  systemfunc("date")
  fileAtt@institution = "C-DAC-PUNE"
  fileAtt@created_by = "sskrishna"
  fileAtt@notes = "Created with NCL script"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Eday=(/"20220712","20220714","20220818","20220912","20221015","20221018"/)

Eday=(/"20220802","20220803","20220825","20220826","20220827","20220829","20220904","20220905"/)


;;;------------------------------
forcst_len = 3 ;; days
M1_out = new((/dimsizes(Eday),forcst_len/),float)
M2_out =new((/dimsizes(Eday),forcst_len/),float)

RF1p5 = new((/dimsizes(Eday),forcst_len,85,83/),float)
RFNC1p5 = new((/dimsizes(Eday),forcst_len,85,83/),float)

;;;----------------!!!!!!!!!!!!!!!!!!!!!!----------------

do j=0,dimsizes(Eday)-1    ;%% HRE_DATES
   print("-------------------------")
   print("------working with HRE_EVENT ON:"+Eday(j))
   print("-------------------------")

nd1=systemfunc("date +%Y%m%d -d "+Eday(j)+"-1day")
nd2=systemfunc("date +%Y%m%d -d "+Eday(j)+"-2day")
nd3=systemfunc("date +%Y%m%d -d "+Eday(j)+"-3day")

yymmdd = (/nd1,nd2,nd3/)

;delete([/nd1,nd2,nd3/])

;;;;=-=========================================
        do i=0,dimsizes(yymmdd)-1   ;%% HRE -Day3,Day2, Day1 forecasts

;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
diri_model="/scratch/sahiduli/sagarp/High_resolution_semiops/"+yymmdd(i)+"00/post-process/"

;;;;;============
;;;Reading data
;;;;;============
   fils="op-d03.nc"
   latS = 12.8 ;18.4
   latE = 13.2; 18.65
   lonS = 77.4 ;73.7
   lonE = 77.8 ;74
   a = addfile(diri_model+fils,"r")
     ref1 = a->rainc((/18,25/),0,{latS:latE},{lonS:lonE})
;printVarSummary(ref1)
;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   print("working with"+yymmdd(i)+"forecast file")
;;----------------------------------------
   if (i.eq.2)
      mrfc = a->rainc((/51,74/),0,{latS:latE},{lonS:lonE})
      mrfnc = a->rainnc((/51,74/),0,{latS:latE},{lonS:lonE})
   end if
;;----------------------------------------
   if (i.eq.1)
      mrfc = a->rainc((/27,50/),0,{latS:latE},{lonS:lonE})
      mrfnc = a->rainnc((/27,50/),0,{latS:latE},{lonS:lonE})
    end if
;;----------------------------------------
    if (i.eq.0)
      mrfc = a->rainc((/3,26/),0,{latS:latE},{lonS:lonE})
      mrfnc = a->rainnc((/3,26/),0,{latS:latE},{lonS:lonE})
    end if
;;----------------------------------------
   tt = (mrfc(1,:,:)+mrfnc(1,:,:))-(mrfc(0,:,:)+mrfnc(0,:,:)) ;; day1 rainfall
   tmrfnc = (mrfnc(1,:,:)-mrfnc(0,:,:)) ;;  rainfall
   copy_VarCoords(ref1(0,:,:),tt)
   copy_VarCoords(ref1(0,:,:),tmrfnc)
;printVarSummary(tt)
             RF1p5(j,i,:,:) = tt
             RFNC1p5(j,i,:,:) = tmrfnc

                delete ([/tt,tmrfnc,mrfc,mrfnc/])

        end do    ; 3-DAYS

                delete([/yymmdd,diri_model/])

end do ; CASES

RF1p5!0="Event_Day"
RF1p5&Event_Day=Eday
RF1p5!1="Forecast_Day"
RF1p5&Forecast_Day=(/"day-1","day-2","day-3"/)
copy_VarCoords(RF1p5,RFNC1p5)
;print(RF1p5&lat@units)
printVarSummary(RFNC1p5)

;;;;---------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;
        setfileoption("nc", "Format",  "NetCDF4")
    out_fname="WRFp5_RF_BENC"         ; filename
    fileformat=".nc"
    system("rm -f "+out_fname+fileformat)  ;it removes pre existing file with the same name
    out=addfile(out_fname+fileformat,"c")
    out->rain=RF1p5(:,:,:,:)
    out->rainnc=RFNC1p5(:,:,:,:)
    out@long_name = "BENC 2022_HRE CASES(8)_(WRF[0.5km]_Quasi-Operational)DATA"
    fileattdef(out, fileAtt)
end


