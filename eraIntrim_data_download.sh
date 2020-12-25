#/bin/bash -x
for (( ii=1979; ii<=2017; ii++)) do
year=$ii
echo $year

cat > ERA$ii.py <<EOF
#!/usr/bin/env python
from ecmwfapi import ECMWFDataServer
server = ECMWFDataServer()
server.retrieve({
    "class": "ei",
    "dataset": "interim",
    'date'      : "$ii-01-01/$ii-02-01/$ii-03-01/$ii-04-01/$ii-05-01/$ii-06-01/$ii-07-01/$ii-08-01/$ii-09-01/$ii-10-01/$ii-11-01/$ii-12-31",
    "expver": "1",
    "grid": "1.0/1.0",
    "levelist": "10/50/100/150/200/250/300/350/400/450/500/550/600/650/700/750/800/825/850/900/950/1000",
    "levtype": "pl",
    "param": "133.128",
    "stream": "moda",
    "type": "an",
    'format'    : "netcdf",
    "target": "SPH_ERA_$ii.nc",
})
EOF

sed -i s/yr/$ii/g ERA$ii.py
python ERA$ii.py
wait
rm ERA$ii.py
done

exit 0
