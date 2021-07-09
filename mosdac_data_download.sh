#!/bin/bash       
##upgraded FTP and SFTP service
$sftp ssk351@download.mosdac.gov.in
$password:

url=ftp://ftp.mosdac.gov.on/Order
for i in {75..94..1};do
echo  wget --user=ssk351 --password=******* $url/Sep19_"0543"${i}"/*"
done
