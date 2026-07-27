#!/bin/csh
# creat input files for a give target
# 
#
set ebeam={$1}
set targ = {$2}
set min_angle={$3}
set num_angle={$4}
set name={$5}

cd ../INP/
# Loop over angles
@ i=1
while ($i <= $num_angle)
    set angle=`echo "$min_angle+$i*0.2-0.2" | bc` 

    set angle_name=`echo "$angle" | tr '.' 'p'`
    set infile = "${name}_${angle_name}_${targ}.inp"
    echo $infile
    sed -e "s/<ebeam>/$ebeam/;s/<angle>/$angle/;s/<targ>/$targ/" < rsidis.template >! $infile
    @ i++
end
