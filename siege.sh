#!/bin/sh

#ROOT_DIR=$(pwd)
#NEW_LOGS_DIR=${ROOT_DIR}/logs_bz2
#HANDLER_DIR=${ROOT_DIR}/James_James_James_handler_directory

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
	rm -rf `ls | grep -v "^qa_siege_performance$"`
	popd
	
done
