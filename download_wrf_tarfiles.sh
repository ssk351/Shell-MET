#!/bin/bash
#########################################################
WRFversion="4.3"
#########################################
wget https://github.com/wrf-model/WRF/archive/refs/tags/v${WRFversion}.tar.gz
wget https://github.com/wrf-model/WRF/archive/v${WRFversion}.tar.gz
mv v${WRFversion}.tar.gz WRFV${WRFversion}.tar.gz
mv v${WRFversion}.tar.gz WRFDAV${WRFversion}.tar.gz
#########################################
WPSversion="4.3"
wget https://github.com/wrf-model/WPS/archive/v${WPSversion}.tar.gz
mv v${WPSversion}.tar.gz WPSV${WPSversion}.TAR.gz

