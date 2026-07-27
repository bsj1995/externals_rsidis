#!/bin/csh
# creat input files for a given target
# 
#
set targ = {$1}
set name = {$2}
set min_angle={$3}
set num_angle=${4}
cd ..
set mydir=$PWD
echo $mydir
cd hcswif/FARM_SCRIPTS
# Loop over angles
@ i=1
while ($i <= $num_angle)
    set angle=`echo "$min_angle+$i*0.2-0.2" | bc` 
    echo $angle
    set angle_name=`echo "$angle" | tr '.' 'p'`
    set infile = "${name}_${angle_name}_${targ}"
    set scriptfile = "${name}_${angle_name}_${targ}.sh"
    echo $infile
    cat script_header.txt >! $scriptfile
    set mycommand = "${mydir}/run_extern_farm ${infile}"
    echo "${mycommand}" >> $scriptfile
    chmod a+x $scriptfile
    @ i++
end


