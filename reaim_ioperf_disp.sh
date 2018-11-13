#!/bin/sh

#ROOT_DIR=$(pwd)
#NEW_LOGS_DIR=${ROOT_DIR}/logs_bz2
#HANDLER_DIR=${ROOT_DIR}/handler_directory

set -x 

working_dir=${HANDLER_DIR}/$1

if ! [ -d ${working_dir} ] ;then
	echo "Working dir ${working_dir} not exist."
	exit 1
fi


echo $0 done.

tarball_list=$(ls ${NEW_LOGS_DIR}/${1}-*.tar.bz2)

for tarball in ${tarball_list}
do
	#extract log tarball no dependence on testsutie
	mkdir t
	pushd t
	tar xf ${tarball}
	log_dir=`ls -tr | tail -n 1`
	rm -rf `ls | grep -v "^${log_dir}$"`
	mv ${log_dir} ../
	popd
	rm -rf t
	#remove noused files dependence on testsutie
	pushd ${log_dir}
	rm -rf `ls | grep -v "^reaim-ioperf$"`
	popd
	
done

new_dir=`pwd`
new_dir_file_list=`ls`
mkdir -pv ${new_dir}/data_group
#x is directory indcate testrun log
for x in ${new_dir_file_list}
do
	pushd $x
	for y in `ls`
	do
	mkdir -pv ${new_dir}/data_group/${y}
	touch ${new_dir}/data_group/${y}/${y}.${x}
	j=1
	for i in $(cat ${y} | grep "^Max Jobs per Minute " | awk '{print $5}');do echo $i >> ${new_dir}/data_group/${y}/${y}.${x}; echo $i >> ${new_dir}/data_group/${y}/line${j};((j++));done
	done
	popd
	
done

mkdir -pv ${new_dir}/result
pushd ${new_dir}/data_group
	for dir in `ls`
	do
	pushd $dir
	echo "==-========debug======"
	echo "j=$j"
	for i in `seq 1 $(($j - 1))`
	do
		echo `cat line$i | awk '{a+=$1}END{printf("%.1f\n",a/NR)}'` >> ${new_dir}/result/$dir
	done
	echo "==-========debugend======"
	popd
	done
popd
exit 0
