#;;----------------------------------------------------
##Script to post-process the data using the wrfouts
## Assume the data as saved in YYYYMMDD format
## Read the date and convert into days, months and years
## you can add the more variables and do the needful changes
#;;----------------------------------------------------


for datetime in 2022061300 2022062700 2022062800 2022062900 2022072900 2022073000 2022073100 2022080100 
2022080200 2022080300  2022082200 2022082300 2022082400 2022082500 2022082600 2022082700 2022082800 
2022082900 2022090100 2022090200 2022090400


do

year="${datetime:0:4}"
month="${datetime:4:2}"
day="${datetime:6:2}"
hour="${datetime:8:2}"

Sd=$day
# Add 3 days to the day component
new_day=$(date -d "${year}-${month}-${day} +3 days" +%d)
new_month=$(date -d "${year}-${month}-${day} +3 days" +%m)
Ed=$new_day
Em=$new_month
#echo $Ed $Em

pp=/scratch/sahiduli/sagarp/High_resolution_semiops/${datetime}/post-process
mkdir -p $pp
cd $pp


#####Running ARWpost ###################################
###### creating ARWpost namelist#####
cat <<EOF > namelist.ARWpost

&datetime
 start_date = '$year-$month-${Sd}_00:00:00',
 end_date   = '$year-$Em-${Ed}_03:00:00',
 interval_seconds = 10800,
 tacc = 0,
 debug_level = 0,
/

&io
 input_root_name = '/scratch/ssk/High_resolution_semiops/${datetime}/wrfout_d02*'
 output_root_name = '/scratch/ssk/High_resolution_semiops/${datetime}/post-process/op-d02'
 plot = 'list'
 fields = 'RAINC,RAINNC'
 mercator_defs = .true.
/
 split_output = .true.
 frames_per_outfile = 2

 plot = 'all'
 plot = 'list'
 plot = 'all_list'
! Below is a list of all available diagnostics

&interp
 interp_method = 1,
 interp_levels = 1000.,950.,900.,850.,800.,750.,700.,650.,600.,550.,500.,450.,400.,350.,300.,250.,200.,150.,100.,
/
 extrapolate = .true.

 interp_method = 0,     ! 0 is model levels, -1 is nice height levels, 1 is user specified pressure/height

 interp_levels = 1000.,950.,900.,850.,800.,750.,700.,650.,600.,550.,500.,450.,400.,350.,300.,250.,200.,150.,100.,
 interp_levels = 0.25, 0.50, 0.75, 1.00, 2.00, 3.00, 4.00, 5.00, 6.00, 7.00, 8.00, 9.00, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0, 17.0, 18.0, 19.0, 20.0,


EOF
cat <<EOF > submit_arw_$datetime.sh
#!/bin/sh
#SBATCH -N 1
#SBATCH --ntasks-per-node=48
#SBATCH --time=04:00:00
##SBATCH --exclude=cn055,cn011
#SBATCH --job-name=${datetime}_d02
#SBATCH --error=./job.%J.err
#SBATCH --output=./job.%J.out
#SBATCH --partition=standard

ulimit -s unlimited
ulimit -c 0

cd $pp

ln -sf /home/ssk/model/ARWpost/*.exe .

source ~/.bashrc

source /opt/ohpc/pub/compiler/intel/2018_update4/compilers_and_libraries_2018.5.274/linux/bin/compilervars.sh intel64
##;;;;;;;;;;;;;;;;;;;;;;;;;;;;

TBEGIN=`echo "print time();" | perl`

####end of creating ARWpost namelist#####
mpirun -np 48 ./ARWpost.exe
##############################################
### converting to Netcdf format
cdo -f nc import_binary op-d02.ctl op-d02.nc
rm *.ctl *.dat

TEND=`echo "print time();" | perl`

echo "++++ Total elapsed time for fcst `expr $TEND - $TBEGIN` seconds"

EOF


sbatch submit_arw_$datetime.sh
done

~

