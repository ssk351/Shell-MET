
#!/bash/bin
#''''''''''''''''''
variables=("x" "y")
models=("a" "b" "c")
#''''''''''''''''''

for i in "${variables[@]}" ;do
    for j in "${models[@]}" ;do
	nfiles=$(ls ${i}${j}* |wc -l)  #;$(ls $i$j*.nc |wc -l)
	echo $nfiles
     if [ $nfiles -gt 1 ]; then
	echo "num files are there"
	cdo mergetime *${i}*.nc ${i}_model.nc
     fi
    done
done

