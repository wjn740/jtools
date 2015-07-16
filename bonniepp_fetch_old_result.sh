#!/bin/bash


#这个结构用于处理一个测试执行产生多个原始数据链接需要被处理的情况。
tiobench_sp3_gm_ext3_1=("https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-12-04-47/tiobench-basic-4096-1" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-12-04-47/tiobench-basic-4096-2" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-12-04-47/tiobench-basic-4096-4" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-12-04-47/tiobench-basic-32768-1" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-12-04-47/tiobench-basic-32768-2" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-12-04-47/tiobench-basic-32768-4")

tiobench_sp3_gm_ext3_2=("https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-09-33-37/tiobench-basic-4096-1" 'https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-09-33-37/tiobench-basic-4096-2' 'https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-09-33-37/tiobench-basic-4096-4' 'https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-09-33-37/tiobench-basic-32768-1' 'https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-09-33-37/tiobench-basic-32768-2' 'https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-09-33-37/tiobench-basic-32768-4')

tiobench_sp3_gm_ext3_3=("https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-06-22-49-32/tiobench-basic-4096-1" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-06-22-49-32/tiobench-basic-4096-2" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-06-22-49-32/tiobench-basic-4096-4" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-06-22-49-32/tiobench-basic-32768-1" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-06-22-49-32/tiobench-basic-32768-2" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-06-22-49-32/tiobench-basic-32768-4")

tiobench_sp3_gm_xfs_1=("https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-10-52-34/tiobench-basic-4096-1" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-10-52-34/tiobench-basic-4096-2" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-10-52-34/tiobench-basic-4096-4" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-10-52-34/tiobench-basic-32768-1" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-10-52-34/tiobench-basic-32768-2" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-10-52-34/tiobench-basic-32768-4")

tiobench_sp3_gm_xfs_2=("https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-08-21-09/tiobench-basic-4096-1" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-08-21-09/tiobench-basic-4096-2" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-08-21-09/tiobench-basic-4096-4" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-08-21-09/tiobench-basic-32768-1" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-08-21-09/tiobench-basic-32768-2" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-07-08-21-09/tiobench-basic-32768-4")

tiobench_sp3_gm_xfs_3=("https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-06-21-36-40/tiobench-basic-4096-1" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-06-21-36-40/tiobench-basic-4096-2" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-06-21-36-40/tiobench-basic-4096-4" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-06-21-36-40/tiobench-basic-32768-1" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-06-21-36-40/tiobench-basic-32768-2" "https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/tiobench-basic-2015-02-06-21-36-40/tiobench-basic-32768-4")

set -e 
set -x

echo "============start============="


. ${ROOT_DIR}/common.sh
. ${ROOT_DIR}/libdata_group.sh

OLD_DIR=../old
if ! [ -d $OLD_DIR ]; then
	mkdir $OLD_DIR
fi

pushd ${OLD_DIR}

bonniepp_extract ${2} ${1}

data_group "bonniepp"

popd
##$1 is OLD_LOGS_DIR's name
#
#OLD_LOGS_DIR=${OLD_DIR}
#pushd ${OLD_LOGS_DIR}
#result_name="tiobench-basic"
#testcase=$2
#
#if echo $testcase | grep "ext3$"; then
#	testcase="tiobench_sp3_gm_ext3"
#fi
#if echo $testcase | grep "xfs$"; then
#	testcase="tiobench_sp3_gm_xfs"
#fi
#
#
#	for i in 1 2 3
#	do
#		arrayname="${testcase}_${i}"
#		eval c="$\{#$arrayname[@]\}"
#		eval "count=$c"
#		for((j=0;j<$count;j++))
#		do
#			eval "item=$\{$arrayname[$j]\}"
#			eval url=$item
#			echo $j ---  $url
#			filename=$(basename ${url});
#			dirname=$(basename $(dirname ${url}));
#			mkdir -vp $dirname;
#			curl ${url} -o $dirname/$filename
#		done
#		pushd $dirname
#		cat `ls -tr` | grep "^[2-4]\.[0-9]*\.[0-9]*-[0-9.]*-[a-z]*" | awk '{print $5}' > ${result_name}
#		popd
#       done
#
#	echo "===========debug1=========="
#	mkdir data_group
#
#	echo "===========debug2=========="
#	#查找所有需要处理的同名文件,依次将每行合并到line${X}文件中。
#	for file in `find . -name ${result_name}`
#	do
#		echo "===========debug3=========="
#		filename=$(basename ${file})
#		mkdir -pv ./data_group/${filename}
#		linenu=1
#		echo "===========${file}=debug4=========="
#		for line in $(cat ${file})
#		do
#			#touch data_group/${filename}/line${j}
#			echo $line >> data_group/${filename}/line${linenu}
#			((linenu++));
#		done
#	done
#
#	#根据每一个line${X}文件，求出每一行的平均值。再将每一个合并。
#	mkdir result
#	i=0
#	for i in `seq 1 $(($linenu - 1))` 
#	do
#		echo `cat data_group/${filename}/line${i} | awk '{a+=$1}END{printf("%.2f\n",a/NR)}'` >> result/${filename}
#	done
#
#popd


#pushd $OLD_DIR
#file_list=`ls`
#mkdir result
#for file in ${file_list}
#do
#	for i in $(cat ${file} | grep "^[2-4]\.[0-9]*\.[0-9]*-[0-9.]*-[a-z]*" | awk '{print $5}');do echo $i >> ${OLD_DIR}/result/${file};done
#done
#popd
