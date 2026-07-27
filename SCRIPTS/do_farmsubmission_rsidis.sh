#!/bin/tcsh
set ebeam={$1}
set targ = {$2}
set min_angle={$3}
set num_angle={$4}
set name={$5}


swif2 cancel externals_${name}_${targ} -delete

#make the batch farm script
cd ..
set mydir=$PWD
echo "cd ${mydir}" >! dir_file.txt
cat dir_file.txt run_extern >! run_extern_farm
chmod a+x run_extern_farm
cd SCRIPTS

./make_input_files.sh $ebeam $targ $min_angle $num_angle $name
./make_rsidis_scripts.sh $targ $name $min_angle $num_angle

cd ../hcswif/FARM_SCRIPTS
readlink -f ${name}*_${targ}*.sh >! ${name}_${targ}_list.txt

cd ..
set mydir=$PWD
set mycommand = "${mydir}/FARM_SCRIPTS/${name}_${targ}_list.txt"

./hcswif.py --mode command --command file $mycommand --name externals_${name}_${targ} --account hallc --time 86400 --ram 50000000

swif2 import -file json/externals_${name}_${targ}.json
swif2 run externals_${name}_${targ}
