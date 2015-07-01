#!/bin/bash


reaim_ioperf_sp3_gm_ext3="https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/reaim-ioperf-2015-02-05-14-27-15/"
reaim_ioperf_sp3_gm_xfs="https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/reaim-ioperf-2015-02-05-18-43-36/"


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
	echo $parent | grep '_ext3$' 
	if [ $? -eq 0 ];then
		echo "==ext3==$parent=========="
		curl $reaim_ioperf_sp3_gm_ext3/reaim-alltests > $OLD_DIR/reaim-alltests
	else
		echo "!=ext3==$parent=========="

	fi
	echo $parent | grep '_xfs$'
	if [ $? -eq 0 ];then
		echo "==xfs===$parent=========="
		curl $reaim_ioperf_sp3_gm_xfs/reaim-alltests > $OLD_DIR/reaim-alltests
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
	for i in $(cat ${file} | grep "^Max Jobs per Minute " | awk '{print $5}');do echo $i >> ${OLD_DIR}/result/${file};done
done
popd
