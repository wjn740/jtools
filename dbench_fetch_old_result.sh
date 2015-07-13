#!/bin/bash


#这个结构用于处理一个测试执行产生多个原始数据链接需要被处理的情况。
dbench_sp3_gm_ext3_1=("https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/dbench-async-4_0-2015-02-26-19-27-43/dbench-default")


dbench_sp3_gm_xfs_1=("https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11/GM/i586/apac2-ph026.apac.novell.com/dbench-async-4_0-2015-02-26-20-48-27/dbench-default")


dbench_sp3_gm_fsync_xfs_1=("https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/dbench-fsync-4_0-2015-02-09-19-55-52/dbench-fsyncIO")
dbench_sp3_gm_fsync_xfs_2=("https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/dbench-fsync-4_0-2015-02-10-01-12-44/dbench-fsyncIO")
dbench_sp3_gm_fsync_xfs_3=("https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/dbench-fsync-4_0-2015-02-10-06-29-13/dbench-fsyncIO")


dbench_sp3_gm_fsync_ext3_1=("https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/dbench-fsync-4_0-2015-02-09-18-37-22/dbench-fsyncIO")
dbench_sp3_gm_fsync_ext3_2=("https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/dbench-fsync-4_0-2015-02-09-23-52-53/dbench-fsyncIO")
dbench_sp3_gm_fsync_ext3_3=("https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/dbench-fsync-4_0-2015-02-10-05-10-36/dbench-fsyncIO")

echo "============start============="


OLD_DIR=../old
if ! [ -d $OLD_DIR ]; then
	mkdir $OLD_DIR
fi

#$1 is OLD_LOGS_DIR's name

OLD_LOGS_DIR=${OLD_DIR}
pushd ${OLD_LOGS_DIR}
testcase=$2

if echo $testcase | grep "^dbench4_ext3$"; then
	testcase="dbench_sp3_gm_ext3"
elif echo $testcase | grep "^dbench4_xfs$"; then
	testcase="dbench_sp3_gm_xfs"
elif echo $testcase | grep "^dbench4_fsync_ext3$"; then
	testcase="dbench_sp3_gm_fsync_ext3"
elif echo $testcase | grep "^dbench4_fsync_xfs$"; then
	testcase="dbench_sp3_gm_fsync_xfs"
fi

result_name=$2_result

	for i in 1 2 3
	do
		arrayname="${testcase}_${i}"
		eval c="$\{#$arrayname[@]\}"
		eval "count=$c"
		if [ -z ${count} ];then
			break
		fi
		for((j=0;j<$count;j++))
		do
			eval "item=$\{$arrayname[$j]\}"
			eval url=$item
			echo $j ---  $url
			filename=$(basename ${url});
			dirname=$(basename $(dirname ${url}));
			mkdir -vp $dirname;
			curl ${url} -o $dirname/$filename
		done
		pushd $dirname
		cat `ls -tr` | grep "^Throughput [0-9].*ms" | awk '{print $2}' > ${result_name}
		popd
       done

	echo "===========debug1=========="
	mkdir data_group

	echo "===========debug2=========="
	#查找所有需要处理的同名文件,依次将每行合并到line${X}文件中。
	for file in `find . -name ${result_name}`
	do
		echo "===========debug3=========="
		filename=$(basename ${file})
		mkdir -pv ./data_group/${filename}
		linenu=1
		echo "===========${file}=debug4=========="
		for line in $(cat ${file})
		do
			#touch data_group/${filename}/line${j}
			echo $line >> data_group/${filename}/line${linenu}
			((linenu++));
		done
	done

	#根据每一个line${X}文件，求出每一行的平均值。再将每一个合并。
	mkdir result
	i=0
	for i in `seq 1 $(($linenu - 1))` 
	do
		echo `cat data_group/${filename}/line${i} | awk '{a+=$1}END{printf("%.4f\n",a/NR)}'` >> result/${filename}
	done

popd


#pushd $OLD_DIR
#file_list=`ls`
#mkdir result
#for file in ${file_list}
#do
#	for i in $(cat ${file} | grep "^[2-4]\.[0-9]*\.[0-9]*-[0-9.]*-[a-z]*" | awk '{print $5}');do echo $i >> ${OLD_DIR}/result/${file};done
#done
#popd
