#!/bin/bash


data_group()
{
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
    case $1 in
    "pgbench")
	for i in $(cat ${y} | grep "^tps" | awk -F " "  '{print $3}');do echo $i >> ${new_dir}/data_group/${y}/${y}.${x}; echo $i >> ${new_dir}/data_group/${y}/line${j};((j++));done
    ;;
    "tiobench")
	for i in $(cat ${y} | grep "^[2-4]\.[0-9]*\.[0-9]*-[0-9.]*-[a-z]*" | awk '{print $5}');do echo $i >> ${new_dir}/data_group/${y}/${y}.${x}; echo $i >> ${new_dir}/data_group/${y}/line${j};((j++));done
    ;;
    "bonniepp")
	for i in $(cat ${y} | grep -A 1 "^Machine" | sed -n 2p | awk '{print $3, $5, $7, $9, $11}');do echo $i >> ${new_dir}/data_group/${y}/${y}.${x}; echo $i >> ${new_dir}/data_group/${y}/line${j};((j++));done
    ;;
    esac
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
		echo `cat line$i | awk '{a+=$1}END{printf("%.2f\n",a/NR)}'` >> ${new_dir}/result/$dir
	done
	popd
	done
popd
}
