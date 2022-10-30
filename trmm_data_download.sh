#/bin/bash
# To download trmm/gpm data with GES DISC
username=ssk351
password=********
touch .netrc
echo "machine urs.earthdata.nasa.gov login $username password $password" >>.netrc
chmod 0600 .netrc
touch .urs_cookies
wget --load-cookies ~/.urs_cookies --save-cookies ~/.urs_cookies --auth-no-challenge=on --keep-session-cookies --content-disposition -i $1


## run like sh filename.sh list of link file

;;;;modified
wget --user=ssk351 --password=Krishna@351 --content-disposition -i /mnt/c/Users/Krishna/Downloads/2018_mj.txt >&18.log&
