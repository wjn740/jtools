#!/bin/sh


export ROOT_DIR=$(pwd)
export NEW_LOGS_DIR=${ROOT_DIR}/logs_bz2
export HANDLER_DIR=${ROOT_DIR}/James_James_James_handler_directory

#sync logs from Testing Server
#pushd ${NEW_LOGS_DIR}
#rsync root@147.2.207.210:/var/log/qaset/log/* .
#popd


test_list=$(ls ${NEW_LOGS_DIR}/*.tar.bz2 | awk -F '-' '{print $1}' | sort -u)
for subdir in ${test_list}
do
	if [ -d ${HANDLER_DIR}/$(basename ${subdir}) ] ;then
		echo "Directory existed ${HANDLER_DIR} abort."
		exit 1
	fi
	mkdir -pv ${HANDLER_DIR}/$(basename ${subdir})

	echo $(basename ${subdir}) >> ${HANDLER_DIR}/.list
done
