array1=($(cat ../SLE-11-SP3/xfs_sp4_liner.txt))
array2=($(cat ../SLE-11-SP4/xfs_sp4_liner.txt))
title1=(write rewrite    read    reread    random_read   random_write    bkwd_read)
title2=(2097152 4194304)
title3=(4096 8192 16384)
printf "%52s\n"	"SP3       SP4    rate"


i=0
for t2 in $(seq 0 $((${#title2[*]} - 1)))
do
   for t3 in $(seq 0 $((${#title3[*]} - 1)))
   do
      for t1 in $(seq 0 $((${#title1[*]} - 1)))
      do
	   printf "%26s %9s %9s %.2f\n" "${title1[$t1]}/${title2[$t2]}/${title3[$t3]}" ${array1[$i]} ${array2[$i]} $(echo "(${array2[$i]}/${array1[$i]})*100"|bc -l)
	((i++))
      done
   done
done
