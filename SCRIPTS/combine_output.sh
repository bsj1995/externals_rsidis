#!/bin/tcsh
set targ = {$1}
set min_angle={$2}
set num_angle=${3}
set name=${4}
cd ../OUT/
cat ../SCRIPTS/header.txt >! ${name}_$targ.out
@ i=1
while ($i <= $num_angle)
    set angle=`echo "$min_angle+$i*0.2-0.2" | bc` 
    set angle_name=`echo "$angle" | tr '.' 'p'`
    set outfile = "${name}_${angle_name}_${targ}.out"
    cat $outfile >! temp.out
    cat temp.out >> ${name}_$targ.out
    @ i++
end


