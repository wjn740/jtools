#!/bin/bash

#ROOT_DIR=$(pwd)
#NEW_LOGS_DIR=${ROOT_DIR}/logs_bz2
#HANDLER_DIR=${ROOT_DIR}/handler_directory

. ${ROOT_DIR}/common.sh

working_dir=${HANDLER_DIR}/$1

if ! [ -d ${working_dir} ] ;then
	echo "Working dir ${working_dir} not exist."
	exit 1
fi


echo $0 done.

dbench_extract ${NEW_LOGS_DIR} ${1}

#build data_group
new_dir=`pwd`
new_dir_file_list=`ls`
mkdir -pv ${new_dir}/data_group
#x is directory
for x in ${new_dir_file_list}
do
	pushd $x
	#y is logfile
	for y in `ls`
	do
	mkdir -pv ${new_dir}/data_group/${y}
	touch ${new_dir}/data_group/${y}/${y}.${x}
	j=1
	for i in $(cat ${y} | grep "^Throughput [0-9].*ms" | awk '{print $2}');do echo $i >> ${new_dir}/data_group/${y}/${y}.${x}; echo $i >> ${new_dir}/data_group/${y}/line${j};((j++));done
	done
	popd
done


mkdir -pv ${new_dir}/result
pushd ${new_dir}/data_group
	for dir in `ls`
	do
	pushd $dir
	for i in `seq 1 $(($j - 1))`
	do
		echo `cat line$i | awk '{a+=$1}END{printf("%.4f\n",a/NR)}'` >> ${new_dir}/result/$1_result
	done
	popd
	done
popd
exit 0
