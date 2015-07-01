#!/bin/bash


kernbench_sp3_gm="https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11/RC2/i586/apac2-ph026.apac.novell.com/kernbench-2015-05-22-17-12-33"


echo "===start==========="
##################################
#NOW WE ARE IN NEW DIR.
##################################

OLD_DIR=../old

if ! [ -d $OLD_DIR ]; then
	mkdir $OLD_DIR
fi
for file in `ls result/*`
do
	string=$(basename ${file})
	echo "========$string=========="
	parent=$(basename $(dirname `pwd`))
	echo "========$parent=========="
	curl $kernbench_sp3_gm/$string > $OLD_DIR/$string
	
done
echo "===end============="



pushd $OLD_DIR
file_list=`ls`
mkdir result
for file in ${file_list}
do
	for i in $(cat ${file} | egrep "^Elapsed Time | ^System Time" | awk '{print $3}');do echo $i >> ${OLD_DIR}/result/${file};done
done
popd
