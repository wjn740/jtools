#!/bin/bash


siege_sp3_gm="https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11/GMC/i586/apac2-ph026.apac.novell.com/qa_siege_performance-2015-06-26-15-47-22"

set -x

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
	curl $siege_sp3_gm/$string > $OLD_DIR/$string
	
done
echo "===end============="



pushd $OLD_DIR
file_list=`ls`
mkdir result
for file in ${file_list}
do
	for i in $(cat ${file} | egrep "^Transaction rate:|^Throughput:" | awk -F ':' '{print $2}'|awk '{print $1}');do echo $i >> ${OLD_DIR}/result/${file};done
done
popd
