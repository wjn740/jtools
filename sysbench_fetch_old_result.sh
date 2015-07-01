#!/bin/bash


sysbench_sp3_gm_ext3="https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/sysbench-oltp-2015-02-26-12-16-56/"
sysbench_sp3_gm_xfs="https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/sysbench-oltp-2015-02-26-13-25-34/"


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
	echo $parent | grep '_ext3$' 
	if [ $? -eq 0 ];then
		echo "==ext3==$parent=========="
		curl $sysbench_sp3_gm_ext3/$string > $OLD_DIR/$string
	else
		echo "!=ext3==$parent=========="

	fi
	echo $parent | grep '_xfs$'
	if [ $? -eq 0 ];then
		echo "==xfs===$parent=========="
		curl $sysbench_sp3_gm_xfs/$string > $OLD_DIR/$string
	else
		echo "!=xfs===$parent=========="
	fi
	
done
echo "===end============="



pushd $OLD_DIR
file_list=`ls`
mkdir result
for file in ${file_list}
do
	for i in $(cat ${file} | grep "total time:.*s" | awk '{print $3}' | awk -F 's' '{print $1}');do echo $i >> ${OLD_DIR}/result/${file};done
done
popd
