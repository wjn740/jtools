#!/bin/bash

#ROOT_DIR=$(pwd)
#NEW_LOGS_DIR=${ROOT_DIR}/logs_bz2
#HANDLER_DIR=${ROOT_DIR}/handler_directory

. ${ROOT_DIR}/common.sh
. ${ROOT_DIR}/libdata_group.sh

working_dir=${HANDLER_DIR}/$1

if ! [ -d ${working_dir} ] ;then
	echo "Working dir ${working_dir} not exist."
	exit 1
fi


echo $0 done.

bonniepp_extract ${NEW_LOGS_DIR} ${1}


data_group "bonniepp"

exit 0
