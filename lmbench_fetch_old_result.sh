#!/bin/bash


set -x 

lmbench_sp3_gm="https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11/GMC/i586/apac2-ph026.apac.novell.com/lmbench-2015-06-26-18-13-34/"


echo "===start==========="
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
	curl $lmbench_sp3_gm/$string > $OLD_DIR/$string
	
done
echo "===end============="



pushd $OLD_DIR
file_list=`ls`
mkdir result
for file in ${file_list}
do
	for i in $(cat ${file} | grep -A 7 '^Context switching' |tail -n 3 |  awk '{print $4, $5, $6, $7, $8, $9, $10}');do echo $i >> ${OLD_DIR}/result/${file};done
done
popd
