#!/bin/bash

netperf_loop4_sp3_gm_tcp="https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/netperf-peer-loop-2015-03-18-17-26-10"
netperf_loop4_sp3_gm_udp="https://w3.suse.de/~rd-qa/Results/ProductTests/SLES-11-SP3/GM/i586/apac2-ph026.apac.novell.com/netperf-peer-loop-2015-03-18-17-26-10"

netperf_loop6_sp3_gm_tcp=""
netperf_loop6_sp3_gm_udp=""

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
	echo $parent | grep 'loop4$' 
	if [ $? -eq 0 ];then
		echo $file | grep '\-tcp$'
		if [ $? -eq 0 ];then
		echo "==tcp==$parent=========="
		curl $netperf_loop4_sp3_gm_tcp/$string > $OLD_DIR/$string
		fi
		echo $file | grep '\-udp$'
		if [ $? -eq 0 ];then
		echo "==udp===$parent=========="
		curl $netperf_loop4_sp3_gm_udp/$string > $OLD_DIR/$string
		fi
	fi

	echo $parent | grep 'loop6$' 
	if [ $? -eq 0 ];then
		echo $file | grep '\-tcp$'
		if [ $? -eq 0 ];then
		echo "==tcp==$parent=========="
		if [ -z $netperf_loop6_sp3_gm_tcp ];then
		continue
		fi
		curl $netperf_loop6_sp3_gm_tcp/$string > $OLD_DIR/$string
		fi
		echo $file | grep '\-udp$'
		if [ $? -eq 0 ];then
		echo "==udp===$parent=========="
		if [ -z $netperf_loop6_sp3_gm_udp ];then
		continue
		fi
		curl $netperf_loop6_sp3_gm_udp/$string > $OLD_DIR/$string
		fi
	fi

done
echo "===end============="


set -x

pushd $OLD_DIR
file_list=`ls`
mkdir result
for file in ${file_list}
do
	touch ${OLD_DIR}/result/${file}

	if echo ${y} | grep '\-tcp$'; then
	for i in $(cat ${file} | grep "^ [0-9]*" | awk '{print $5}');do echo $i >> ${OLD_DIR}/result/${file};done
	fi
	if echo ${y} | grep '\-udp$'; then
	for i in $(cat ${file} | egrep '^[0-9]+'| head -n 2 | awk '{if(NR==1)print $6;if(NR==2) print $4;}');do echo $i >> ${OLD_DIR}/result/${file};done
	fi
done
popd
