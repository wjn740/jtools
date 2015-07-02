#!/bin/bash


#这个结构用于处理一个测试执行产生多个原始数据链接需要被处理的情况。
tiobench_sp3_gm_ext3=("https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-12-04-47/tiobench-basic-4096-1" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-12-04-47/tiobench-basic-4096-2" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-12-04-47/tiobench-basic-4096-4" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-12-04-47/tiobench-basic-32768-1" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-12-04-47/tiobench-basic-32768-2" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-12-04-47/tiobench-basic-32768-4")
tiobench_sp3_gm_xfs=("https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-10-52-34/tiobench-basic-4096-1" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-10-52-34/tiobench-basic-4096-2" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-10-52-34/tiobench-basic-4096-4" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-10-52-34/tiobench-basic-32768-1" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-10-52-34/tiobench-basic-32768-2" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-10-52-34/tiobench-basic-32768-4")


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
		#将多个原始数据合并成一个
		for i in $(seq 0 $((${#tiobench_sp3_gm_ext3[@]} - 1)))
		do
			curl ${tiobench_sp3_gm_ext3[$i]} >> $OLD_DIR/$string
		done
	else
		echo "==!=ext3==$parent=========="
	fi
set -x
	echo $parent | grep '_xfs$'
	if [ $? -eq 0 ];then
		echo "==xfs===$parent=========="
		#将多个原始数据合并成一个
		for i in $(seq 0 $((${#tiobench_sp3_gm_xfs[@]} - 1)))
		do
			curl ${tiobench_sp3_gm_xfs[$i]} >> $OLD_DIR/$string
		done
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
	for i in $(cat ${file} | grep "^[2-4]\.[0-9]*\.[0-9]*-[0-9.]*-[a-z]*" | awk '{print $5}');do echo $i >> ${OLD_DIR}/result/${file};done
done
popd
